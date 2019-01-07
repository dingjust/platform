import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';

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

  void _handleUserTypeChanged(String value) {
    setState(() {
      _userType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('注册'),
      ),
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Card(
                child: Container(
              padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
              child: Column(
                children: <Widget>[
                  TextFormField(
                      autofocus: false,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          labelText: '手机号码',
                          hintText: '请输入',
                          suffixIcon: FlatButton(
                            onPressed: () {},
                            color: Colors.grey[200],
                            child: Text(
                              '发送验证码',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '手机号码不能为空';
                      }),
                  TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.phone,
                      controller: _captchaController,
                      decoration: InputDecoration(
                        labelText: '验证码',
                        hintText: '请输入',
                      ),
                      // 校验用户名
                      validator: (v) {
                        return v.trim().length > 0 ? null : '验证码不能为空';
                      }),
                  TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.phone,
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
                      keyboardType: TextInputType.phone,
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
                      groupValue: ['brand', 'factory', 'customer'],
                      onChanged: _handleUserTypeChanged,
                      value: _userType,
                    ),
                  ),
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '已经阅读或同意《衣加衣协议》',
                    style: TextStyle(
                        color: _isAgree ? Colors.orange : Colors.black54),
                  ),
                  Checkbox(
                    onChanged: (v) {
                      setState(() {
                        _isAgree = v;
                      });
                    },
                    value: _isAgree,
                  )
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                _nextStep();
              },
              color: Colors.blue,
              child: Text(
                '下一步',
                style: TextStyle(color: Colors.white),
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
      case 'customer':
        Navigator.pushNamed(context, AppRoutes.ROUTE_MY_REGISTER_CUSTOMER);
        break;
    }
  }
}

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector(
      {Key key, @required this.value, this.groupValue, this.onChanged})
      : super(key: key);

  final String value;
  final List<String> groupValue;

  final ValueChanged<String> onChanged;

  void _handleTap(String v) {
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = groupValue
        .map((v) => GestureDetector(
              onTap: () {
                _handleTap(v);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      v,
                      style: TextStyle(
                          color: v == value ? Colors.orange : Colors.black54),
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
