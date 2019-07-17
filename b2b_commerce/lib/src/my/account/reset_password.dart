import 'dart:async';

import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart' show UserBLoC, UserRepositoryImpl;
import 'package:widgets/widgets.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    Key key,
  }) : super(key: key);

  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  bool validate = false;
  String phoneValidateStr = "";

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _againPasswordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            iconTheme: IconThemeData(color: Color.fromRGBO(36, 38, 41, 1)),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              '重置密码',
              style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
            ),
          ),
          body: Form(
            key: _formKey,
            autovalidate: true,
            child: _buildBody(context),
          )),
    );
  }

  _startTimer() {
    _seconds = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  Widget _buildInputArea() {
    TextField _phoneField = TextField(
      autofocus: false,
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      onChanged: (value) {
        formValidate();
      }, //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
    );

    TextFormField _passwordField = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      // onChanged: (value) {
      //   formValidate();
      // },
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
      validator: (value) {
        if (!RegexUtil.password(value)) {
          return '6~20位字母与数字组合，首位为字母';
        } else {
          return null;
        }
      },
    );

    TextFormField _againPasswordField = TextFormField(
      autofocus: false,
      controller: _againPasswordController,
      obscureText: true,
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
      validator: (value) {
        return _againPasswordController.text == _passwordController.text
            ? null
            : '密码不一致';
      },
    );

    TextField _smsCaptchaField = TextField(
      autofocus: false,
      controller: _smsCaptchaController,
      onChanged: (value) {
        formValidate();
      },
      decoration: InputDecoration(
        hintText: '请输入',
        border: InputBorder.none,
      ),
      // 校验用户名
    );

    _againPasswordController.addListener(() {
      formValidate();
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: <Widget>[
          InputRow(
            label: '手机号码',
            field: _phoneField,
            surfix: Container(
              child: Text(
                phoneValidateStr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          InputRow(
            label: '验证码',
            field: _smsCaptchaField,
            surfix: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: (_seconds == 0)
                  ? () async {
                      bool isExist = await validatePhone();
                      if (isExist) {
                        UserRepositoryImpl()
                            .sendCaptcha(_phoneController.text)
                            .then((a) {
                          _startTimer();
                        });
                      }
                    }
                  : null,
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '$_verifyStr',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          // InputRow(
          //   label: '新密码',
          //   field: _passwordField,
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 85,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '密码',
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _passwordField,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 85,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '再次输入',
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _againPasswordField,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    bloc.loginStream.listen((result) {
      Navigator.pop(context);
      showDialog(
          context: context,
          child: SimpleDialog(
            title: Text('登录失败'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text('${result}'),
              ),
            ],
          ));
    });

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          'temp/login_background.png',
          package: "assets",
        ),
        fit: BoxFit.fitWidth,
      )),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        children: <Widget>[
          _buildInputArea(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              onPressed: validate ? onSubmit : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '提交',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> validatePhone() async {
    String result = "";
    bool isExist = false;

    if (_phoneController.text == '') {
      result = '';
    } else {
      if (RegexUtil.isMobile(_phoneController.text)) {
        UserType type =
            await UserRepositoryImpl().phoneExist(_phoneController.text);

        if (type != null && type != UserType.DEFAULT) {
          result = "";
          isExist = true;
        } else {
          result = "账号不存在";
        }
      } else {
        result = "输入正确手机号";
      }
    }

    setState(() {
      phoneValidateStr = result;
    });

    return isExist;
  }

  void formValidate() {
    setState(() {
      validate = _phoneController.text.trim().length > 0 &&
          _smsCaptchaController.text.trim().length > 0 &&
          _passwordController.text.trim().length > 0 &&
          _againPasswordController.text.trim().length > 0 &&
          _passwordController.text == _againPasswordController.text;
    });
  }

  void onSubmit() async {
    // 加载条
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ProgressIndicatorFactory.buildDefaultProgressIndicator(),
    );

    UserRepositoryImpl()
        .resetPassword(_phoneController.text, _passwordController.text,
            _smsCaptchaController.text)
        .then((value) {
      if (value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => B2BLoginPage(
                      snackBarMessage: '重置密码成功',
                    )),
            ModalRoute.withName('/'));
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '重置密码失败',
                callbackResult: false,
              );
            });
      }
    });
  }
}

class PrefixText extends StatelessWidget {
  final String text;

  const PrefixText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Text(
        text,
        style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
      ),
      margin: EdgeInsets.only(right: 20),
    );
  }
}
