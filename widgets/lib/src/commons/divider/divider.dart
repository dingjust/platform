import 'package:flutter/material.dart';

class DividerFactory {
  static Widget buildDefaultDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: const Divider(height: 1.0),
    );
  }

  static Widget buildDivider(double height, {Color color = const Color.fromRGBO(246, 247, 249, 1)}) {
    return Container(
      color: color,
      height: height,
    );
  }
}
