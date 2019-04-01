import 'package:flutter/material.dart';

/// 文本工厂
class TextFactory {
  static Text buildEmptyText({double fontSize = 15, Color color = Colors.red}) {
    return Text(' ', style: TextStyle(fontSize: fontSize, color: color));
  }
}
