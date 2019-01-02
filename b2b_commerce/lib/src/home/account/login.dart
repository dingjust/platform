import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class B2BLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户登录'),
      ),
      body: LoginPage(Image.asset(
        'temp/login_logo.png',
        package: 'assets',
        width: 60.0,
        height: 60.0,
      )),
    );
  }
}
