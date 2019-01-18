import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widgets/src/account/user_bloc_provider.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(
      {Key key,
      @required this.logo,
      this.registerRoute,
      this.forgetPasswordRoute})
      : super(key: key);

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
  bool _isPasswordLogin = true;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, widget.registerRoute);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
            child: Text(
              '注册',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, widget.forgetPasswordRoute);
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
            child: Text(
              '忘记密码',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        )
      ],
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
              child: Icon(_isPasswordHide
                  ? B2BIcons.eye_not_see
                  : Icons.remove_red_eye),
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
              onPressed: (_seconds == 0)
                  ? () {
                      setState(() {
                        _startTimer();
                      });
                    }
                  : null,
              color: Colors.grey[200],
              child: Text(
                '$_verifyStr',
                style: TextStyle(color: Colors.grey),
              ),
            )),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '密码不能为空';
        });

    return Card(
        child: Container(
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
          _isPasswordLogin ? _smsCaptchaField : _passwordField,
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
                  _isPasswordLogin ? '账号密码登陆' : '短信验证码登陆',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Row(
                children: <Widget>[
                  Text('记住账号'),
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
    ));
  }

  Widget _buildLogo() {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20), child: widget.logo);
  }

  Widget _buildBody(BuildContext context) {
    final bloc = UserBlocProvider.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      children: <Widget>[
        _buildLogo(),
        _buildInputArea(),
        Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: RaisedButton(
            onPressed: () {
              bloc.login(username: 'nbyjy', password: 'z123456')
                  .then((success) {
                if (success) {
                  Navigator.pop(context);
                }
              });
            },
            color: Colors.blue,
            child: Text(
              '登陆',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        _buildServiceRow()
      ],
    );
  }
}
