import 'package:b2b_commerce/src/my/account/register.dart';
import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class B2BLoginPage extends StatelessWidget {
  final String snackBarMessage;

  const B2BLoginPage({Key key, this.snackBarMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage(
        logo: Image.asset(
          'temp/login_logo.png',
          package: 'assets',
          width: 100.0,
          height: 100.0,
        ),
        registerPage: RegisterPage(
          logo: Image.asset(
            'temp/login_logo.png',
            package: 'assets',
            width: 100.0,
            height: 100.0,
          ),
        ),
        forgetPasswordPage: ResetPasswordPage(),
        snackBarMessage: snackBarMessage);
  }
}
