import 'package:flutter/material.dart';

class DividerFactory {
  static Widget buildDefaultDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: const Divider(height: 1.0),
    );
  }
}
