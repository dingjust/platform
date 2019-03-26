import 'package:b2b_commerce/src/my/account/register.dart';
import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class B2BLoginPage extends StatelessWidget {
  final bool isLoginSuccess;

  const B2BLoginPage({Key key, this.isLoginSuccess = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage(
      logo: Image.asset(
        'temp/login_logo.png',
        package: 'assets',
        width: 100.0,
        height: 100.0,
      ),
      registerPage: RegisterPage(),
      forgetPasswordPage: ResetPasswordPage(),
      isLoginSuccess: isLoginSuccess,
    );
  }
}
