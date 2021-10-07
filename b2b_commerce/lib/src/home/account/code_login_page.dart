import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'account_select_login.dart';

///验证码登录页面
class CodeLoginPage extends StatefulWidget {
  ///账号数，默认1
  final int accountNum;

  ///手机号
  final String phone;

  const CodeLoginPage({Key key, this.accountNum = 1, this.phone})
      : super(key: key);

  @override
  _CodeLoginPageState createState() => _CodeLoginPageState();
}

class _CodeLoginPageState extends State<CodeLoginPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  ///倒计时间
  int countdownTime = 60;
  CountdownController controller;

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Color(0xFF222222), width: 0.5)));
  }

  @override
  void initState() {
    super.initState();
    controller = CountdownController();
    WidgetsBinding.instance.addPostFrameCallback((_) => controller.restart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'img/icons/b2b-v2/logo@3x.png',
                  package: 'assets',
                  width: 96,
                  height: 117,
                )),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 60),
              margin: EdgeInsets.only(bottom: 21),
              child: PinPut(
                  fieldsCount: 4,
                  eachFieldWidth: 50,
                  onSubmit: _onSubmit,
                  focusNode: _pinPutFocusNode,
                  autofocus: true,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration,
                  selectedFieldDecoration: _pinPutDecoration.copyWith(
                      border: Border(bottom: BorderSide(color: Colors.yellow))),
                  followingFieldDecoration: _pinPutDecoration),
            ),
            Countdown(
              controller: controller,
              seconds: countdownTime,
              build: (_, double time) => TextButton(
                onPressed: (time == 0 || time == countdownTime)
                    ? () async {
                        controller.restart();
                        UserRepositoryImpl.loginByCaptcha(widget.phone);
                      }
                    : null,
                child: Text(
                  (time == 0 || time == countdownTime)
                      ? '重新获取验证码'
                      : '重新获取验证码(${time.toInt()}s)',
                  style: TextStyle(color: Color(0xFF222222), fontSize: 14),
                ),
              ),
              interval: Duration(milliseconds: 1000),
              onFinished: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit(String code) async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: true);

    //多账号选择登录
    if (widget.accountNum > 1) {
      BaseResponse response =
          await UserRepositoryImpl.validateCaptchaAccount(widget.phone, code);
      if (response == null) {
        cancelFunc.call();
        BotToast.showText(text: '未知错误');
      } else {
        cancelFunc.call();
        if (response.code == 0)
          BotToast.showText(text: '${response.msg}');
        else {
          List<B2BCustomerModel> models = (response.data as List)
              ?.map((e) => e == null
                  ? null
                  : B2BCustomerModel.fromJson(e as Map<String, dynamic>))
              ?.toList();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AccountSelectLogin(
                  phone: widget.phone, code: code, data: models)));
        }
      }
    } else {
      if (widget.accountNum == 0) {
        //未注册
        BaseResponse defaultRes =
            await UserRepositoryImpl.defaultRegister(widget.phone, code);
        if (defaultRes == null) {
          cancelFunc.call();
          BotToast.showText(text: '未知错误');
          throw Exception('未知错误');
        } else {
          if (defaultRes.code == 0) {
            cancelFunc.call();
            BotToast.showText(text: '${defaultRes.msg}');
            throw Exception('${defaultRes.msg}');
          } else {
            //替换Code
            code = defaultRes.data;
          }
        }
      }

      //单账号直接登录
      LoginResult result = await UserBLoC.instance
          .loginByAuthorizationCode(code: code, remember: true);
      cancelFunc.call();
      if (result == LoginResult.SUCCESS) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      } else {
        BotToast.showText(
          text: '验证码错误',
          align: Alignment.center,
          duration: Duration(seconds: 3),
          clickClose: true,
        );
      }
    }
  }
}
