import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class DateBar extends StatefulWidget implements PreferredSizeWidget {
  const DateBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 100,
      @required this.entries,
      this.unselectedColor = Colors.black54,
      this.color = Colors.orange,
      @required this.streamController,
      this.action})
      : super(key: key);

  _DateBarState createState() => _DateBarState();

  final List<FilterConditionEntry> entries;
  final double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final Widget action;
  final StreamController streamController;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Row(
          children: <Widget>[],
        ));
  }
}
