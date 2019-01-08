import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class B2BLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPage(
      logo: Image.asset(
        'temp/login_logo.png',
        package: 'assets',
        width: 100.0,
        height: 100.0,
      ),
      registerRoute: AppRoutes.ROUTE_MY_REGISTER,
    );
  }
}
