import 'package:flutter/material.dart';

// AppBar工厂
class AppBarFactory {
  static Widget buildDefaultAppBar(String title, {List<Widget> actions}) {
    Widget _buildTitle() {
      return Text(title,
          style: TextStyle(
              color: Color(0xff000000),
              fontSize: 18,
              fontWeight: FontWeight.bold));
    }

    return AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0,
      title: _buildTitle(),
      actions: actions,
    );
  }
}
