import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart' show UserBLoC;
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';
import 'package:widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
    @required this.logo,
    this.registerRoute,
    this.forgetPasswordRoute,
  }) : super(key: key);

  final Image logo;
  final String registerRoute;
  final String forgetPasswordRoute;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
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

  Widget _buildServiceRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _isPasswordLogin
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, widget.forgetPasswordRoute);
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
                    child: Text(
                      '忘记密码',
                      style: TextStyle(color: Colors.red, fontSize: 15),
                    ),
                  ),
                )
              : Container(),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, widget.registerRoute);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
              child: Text(
                '注册',
                style: TextStyle(color: Colors.orange, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    TextFormField _passwordField = TextFormField(
        autofocus: false,
        controller: _passwordController,
        obscureText: _isPasswordHide,
        decoration: InputDecoration(
            labelText: '密码',
            hintText: '请输入',
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordHide = !_isPasswordHide;
                });
              },
              child: Icon(
                _isPasswordHide ? B2BIcons.eye_not_see : Icons.remove_red_eye,
                color: Colors.black54,
              ),
            )),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '密码不能为空';
        });

    TextFormField _smsCaptchaField = TextFormField(
        autofocus: false,
        controller: _smsCaptchaController,
        decoration: InputDecoration(
          labelText: '验证码',
          hintText: '请输入',
          suffixIcon: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: (_seconds == 0)
                ? () {
                    setState(() {
                      _startTimer();
                    });
                  }
                : null,
            color: Colors.orange,
            child: Text(
              '$_verifyStr',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '密码不能为空';
        });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              maxLength: 11,
              //只能输入数字
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: '手机号',
                hintText: '请输入',
              ),
              // 校验用户名
              validator: (v) {
                return v.trim().length > 0 ? null : '手机号不能为空';
              }),
          _isPasswordLogin ? _passwordField : _smsCaptchaField,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordLogin = !_isPasswordLogin;
                  });
                },
                child: Text(
                  _isPasswordLogin ? '短信验证码登陆' : '密码登陆',
                  style: TextStyle(color: Colors.orange, fontSize: 15),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '记住账号',
                    style: TextStyle(
                        fontSize: 15,
                        color: _isRemember ? Colors.orange : Colors.black54),
                  ),
                  Checkbox(
                    onChanged: (v) {
                      setState(() {
                        _isRemember = v;
                      });
                    },
                    value: _isRemember,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20), child: widget.logo);
  }

  Widget _buildBody(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

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
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        children: <Widget>[
          _buildLogo(),
          _buildInputArea(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              onPressed: () {
                bloc
                    .login(username: 'nbyjy', password: 'z123456')
                    .then((success) {
                  if (success) {
                    Navigator.pop(context);
                  }
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '登陆',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          _buildServiceRow()
        ],
      ),
    );
  }
}
