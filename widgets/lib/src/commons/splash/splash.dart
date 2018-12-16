import 'dart:async';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Image.asset("images/logo.png");
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  // 倒计时
  void countDown() {
    Duration _duration = const Duration(seconds: 5);
    Future.delayed(
        _duration, () => Navigator.of(context).pushReplacementNamed('/home')
    );
  }
}
