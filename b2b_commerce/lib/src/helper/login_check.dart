import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

abstract class LoginCheck {
  ///检测用户登录状态
  void checkLoginStatus(BuildContext context) {
    if (UserBLoC.instance.currentUser.status == UserStatus.OFFLINE) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => B2BLoginPage()),
          ModalRoute.withName('/'));
    }
  }
}
