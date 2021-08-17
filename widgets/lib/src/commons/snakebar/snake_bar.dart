import 'package:flutter/material.dart';

class SnakeBarFactory {
  static buildDefaultSnakeBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  // 如果弹不出请用这个
  static buildSnakeBarByKey(final GlobalKey<ScaffoldState> key, BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    key.currentState!.showSnackBar(snackBar);
  }
}
