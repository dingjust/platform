import 'package:flutter/material.dart';

class FormDivider extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const FormDivider(
      {Key key, this.margin = const EdgeInsets.symmetric(horizontal: 12)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Divider(
        color: Color(0xFFE7E7E7),
        height: 1,
      ),
    );
  }
}
