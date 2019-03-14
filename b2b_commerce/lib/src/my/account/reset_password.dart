import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart' show UserBLoC;
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
    TextFormField _phoneField = TextFormField(
      autofocus: false,
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
    );

    TextFormField _passwordField = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
      // 校验用户名
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

    TextFormField _smsCaptchaField = TextFormField(
      autofocus: false,
      controller: _smsCaptchaController,
      decoration: InputDecoration(
        hintText: '请输入',
        border: InputBorder.none,
      ),
      // 校验用户名
    );

    //监听密码输入变动、刷新表单校验
    _passwordController.addListener(() {
      setState(() {});
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: <Widget>[
          InputRow(
            label: '手机号码',
            field: _phoneField,
          ),
          InputRow(
            label: '验证码',
            field: _smsCaptchaField,
            surfix: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              onPressed: (_seconds == 0)
                  ? () {
                      setState(() {
                        _startTimer();
                      });
                    }
                  : null,
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '$_verifyStr',
                style: TextStyle(
                    color: (_seconds == 0) ? Colors.white : Colors.black45),
              ),
            ),
          ),
          InputRow(
            label: '新密码',
            field: _passwordField,
          ),
          InputRow(
            label: '再次输入',
            field: _againPasswordField,
          )
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
            title: Text('登陆失败'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text('${result.response}'),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('${result.message}'),
              )
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
              onPressed: formValidate()
                  ? () {
                      //加载条
                      showDialog(
                          context: context,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ));
                      // bloc
                      //     .login(
                      //         username: _phoneController.text,
                      //         password: _passwordController.text,
                      //         remember: _isRemember)
                      //     .then((result) {});
                    }
                  : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '提交',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool formValidate() {
    return _phoneController.text.trim().length > 0 &&
        _smsCaptchaController.text.trim().length > 0 &&
        _passwordController.text == _againPasswordController.text;
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

class InputRow extends StatelessWidget {
  final String label;

  final TextFormField field;

  final Widget surfix;

  const InputRow({Key key, this.label, this.field, this.surfix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            margin: EdgeInsets.only(right: 20),
            child: Text(
              label,
              style:
                  TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: field,
          ),
          surfix ?? Container()
        ],
      ),
    );
  }
}
