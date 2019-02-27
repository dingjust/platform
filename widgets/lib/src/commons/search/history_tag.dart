import 'package:flutter/material.dart';

class HistoryTag extends StatelessWidget {
  HistoryTag({Key key, @required this.value, @required this.onTap})
      : super(key: key);

  final String value;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        label: Text(
          value,
          style: TextStyle(),
        ),
      ),
    );
  }
}
