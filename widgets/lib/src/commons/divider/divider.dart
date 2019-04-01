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

  static Widget buildVerticalSeparator(double height, {double borderWidth = 1}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: borderWidth,
            color: Color.fromRGBO(220, 220, 220, 1),
          ),
        ),
      ),
    );
  }

  static Widget buildHorizontalSeparator(double horizontalWidth, double verticalWidth, {double borderWidth = 0.8}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalWidth, vertical: verticalWidth),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: borderWidth,
            color: Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
      ),
    );
  }
}
