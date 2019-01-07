import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = true;

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              color: Colors.grey[200],
              child: Text(
                '发送短信',
                style: TextStyle(color: Colors.grey),
              ),
            )),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '密码不能为空';
        });

    return Container(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('登陆'),
          ),
          body: Form(
            key: _formKey,
            autovalidate: true,
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 20),
                  child: Image.asset(
                    'temp/login_logo.png',
                    package: 'assets',
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
                Card(
                    child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.phone,
                          controller: _phoneController,
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
                )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: RaisedButton(
                    onPressed: () {},
                    color: Colors.blue,
                    child: Text(
                      '登陆',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.ROUTE_MY_REGISTER);
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
                      onTap: null,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
                        child: Text(
                          '忘记密码',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
