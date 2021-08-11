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
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12),
        label: Text(
          value,
          style: TextStyle(
              color: Color(0xff666666),
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
