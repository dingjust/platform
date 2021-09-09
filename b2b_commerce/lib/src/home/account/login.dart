import 'package:flutter/material.dart';

import 'login_page.dart';

class B2BLoginPage extends StatelessWidget {
  final String snackBarMessage;

  const B2BLoginPage({Key key, this.snackBarMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginPage(snackBarMessage: snackBarMessage);
  }
}
