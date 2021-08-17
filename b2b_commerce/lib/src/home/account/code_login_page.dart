import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
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
  final CountdownController controller = CountdownController();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5.0), color: Colors.grey[100]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('短信快捷登录'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Image.asset(
                'temp/login_logo.png',
                package: 'assets',
                width: 60.0,
                height: 60.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text('我们将以短信的形式将验证码发送给您'),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: PinPut(
                  fieldsCount: 4,
                  eachFieldWidth: 50,
                  onSubmit: _onSubmit,
                  focusNode: _pinPutFocusNode,
                  autofocus: true,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration,
                  selectedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.yellow,
                    ),
                  ),
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
                  style: TextStyle(color: Constants.THEME_COLOR_MAIN),
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
