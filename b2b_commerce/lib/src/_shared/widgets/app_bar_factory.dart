import 'package:flutter/material.dart';

// AppBar工厂
class AppBarFactory {
  static Widget buildDefaultAppBar(String title, {List<Widget> actions}) {
    Widget _buildTitle() {
      return Text(title, style: TextStyle(color: Colors.black));
    }

    return AppBar(
      brightness: Brightness.light,
      centerTitle: true,
      elevation: 0.5,
      title: _buildTitle(),
      actions: actions,
    );
  }
}
