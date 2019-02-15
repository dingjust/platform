import 'dart:async';

import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();

  bool _isAgree = true;
  String _userType = "brand";
  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;

  void _handleUserTypeChanged(String value) {
    setState(() {
      _userType = value;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('注册'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      autofocus: false,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: '手机号码',
                        hintText: '请输入',
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '手机号码不能为空';
                      }),
                  TextFormField(
                      autofocus: false,
                      controller: _captchaController,
                      decoration: InputDecoration(
                          labelText: '验证码',
                          hintText: '请输入',
                          suffixIcon: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            color: Colors.orange,
                            onPressed: (_seconds == 0)
                                ? () {
                                    setState(() {
                                      _startTimer();
                                    });
                                  }
                                : null,
                            child: Text(
                              '$_verifyStr',
                              style: TextStyle(
                                  color: (_seconds == 0)
                                      ? Colors.white
                                      : Colors.black45),
                            ),
                          )),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '验证码不能为空';
                      }),
                  TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: '密码',
                        hintText: '请输入',
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '密码不能为空';
                      }),
                  TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: _passwordAgainController,
                      decoration: InputDecoration(
                        labelText: '确认密码',
                        hintText: '再次输入密码',
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '请再次输入密码';
                      }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30.0, 0, 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('请选择一种角色'),
                        Text(
                          '对角色有疑问？',
                          style: TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.underline),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: UserTypeSelector(
                      userTypeEntries: [
                        UserTypeEntry(
                            value: 'brand',
                            label: '品牌商',
                            icon: Icon(
                              B2BIcons.brand,
                              size: 40,
                              color: Color.fromRGBO(255, 184, 2, 1.0),
                            )),
                        UserTypeEntry(
                            value: 'factory',
                            label: '工厂',
                            icon: Icon(
                              B2BIcons.factory,
                              size: 40,
                              color: Color.fromRGBO(111, 142, 244, 1.0),
                            )),
                        UserTypeEntry(
                            value: 'purchase',
                            label: '采购商',
                            icon: Icon(
                              B2BIcons.purchase,
                              size: 40,
                              color: Color.fromRGBO(62, 185, 254, 1.0),
                            ))
                      ],
                      onChanged: _handleUserTypeChanged,
                      value: _userType,
                    ),
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: (_formKey.currentState as FormState) == null
                  ? null
                  : (_formKey.currentState as FormState).validate()
                      ? () {
                          _nextStep();
                        }
                      : null,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              color: Colors.orange,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '下一步',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Checkbox(
                    onChanged: (v) {
                      setState(() {
                        _isAgree = v;
                      });
                    },
                    value: _isAgree,
                  ),
                  Text(
                    '已经阅读或同意《衣加衣协议》',
                    style: TextStyle(
                        color: _isAgree ? Colors.orange : Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    switch (_userType) {
      case 'brand':
        Navigator.pushNamed(context, AppRoutes.ROUTE_MY_REGISTER_BRAND);
        break;
      case 'factory':
        Navigator.pushNamed(context, AppRoutes.ROUTE_MY_REGISTER_FACTORY);
        break;
      case 'purchase':
        Navigator.pushNamed(context, AppRoutes.ROUTE_MY_REGISTER_CUSTOMER);
        break;
    }
  }
}

class UserTypeEntry {
  final String label;
  final String value;
  final Icon icon;

  UserTypeEntry({this.label, this.value, this.icon});
}

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector(
      {Key key, @required this.value, this.userTypeEntries, this.onChanged})
      : super(key: key);

  final String value;
  final List<UserTypeEntry> userTypeEntries;

  final ValueChanged<String> onChanged;

  void _handleTap(String v) {
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = userTypeEntries
        .map((v) => GestureDetector(
              onTap: () {
                _handleTap(v.value);
              },
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: v.icon,
                    ),
                    Text(
                      v.label,
                      style: TextStyle(
                          color: v.value == value
                              ? Colors.orange
                              : Colors.black54),
                    )
                  ],
                ),
              ),
            ))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgetList,
    );
  }
}

class RegisterInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String remind;
  final bool validate;

  const RegisterInput(
      {Key key,
      @required this.controller,
      @required this.labelText,
      @required this.remind,
      this.validate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText, hintText: '请输入', border: InputBorder.none),
          // 校验用户名
          validator: (v) {
            if (validate) {
              return v.trim().length > 0 ? null : remind;
            } else {
              return null;
            }
          }),
    );
  }
}
