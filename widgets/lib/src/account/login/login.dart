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
    this.registerPage,
    this.forgetPasswordRoute,
  }) : super(key: key);

  final Image logo;
  final Widget registerPage;
  final String forgetPasswordRoute;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

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
              // Navigator.pushNamed(context, widget.registerRoute);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget.registerPage));
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 20),
              child: Text(
                '注册',
                style: TextStyle(
                    color: Color.fromRGBO(255, 214, 12, 1), fontSize: 15),
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
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '$_verifyStr',
              style: TextStyle(
                  color: (_seconds == 0) ? Colors.white : Colors.black45),
            ),
          ),
        ),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '验证码不能为空';
        });

    //监听密码输入变动、刷新表单校验
    _passwordController.addListener(() {
      setState(() {});
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          // Container(
          //   padding: EdgeInsets.all(5),
          //   margin: EdgeInsets.all(10),
          //   child: TextFieldComponent(
          //     focusNode: _phoneFocusNode,
          //     controller: _phoneController,
          //     autofocus: true,
          //     leadingText: '联系人名',
          //     hintText: '请输入联系人名',

          //   ),
          // ),
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
                  style: TextStyle(
                      color: Color.fromRGBO(255, 214, 12, 1), fontSize: 15),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '记住账号',
                    style: TextStyle(
                        fontSize: 15,
                        color: _isRemember
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.black54),
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
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
        children: <Widget>[
          _buildLogo(),
          _buildInputArea(),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RaisedButton(
              onPressed: (_formKey.currentState as FormState) == null
                  ? null
                  : (_formKey.currentState as FormState).validate()
                      ? () {
                          //加载条
                          showDialog(
                              context: context,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ));

                          bloc
                              .login(
                                  username: _phoneController.text,
                                  password: _passwordController.text,
                                  remember: _isRemember)
                              .then((result) {});
                        }
                      : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Color.fromRGBO(255, 214, 12, 1),
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
