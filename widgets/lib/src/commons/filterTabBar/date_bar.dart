import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateBar extends StatefulWidget implements PreferredSizeWidget {
  const DateBar({
    Key key,
    @required this.streamController,
    this.width = 100,
    this.height = 10,
  }) : super(key: key);

  _DateBarState createState() => _DateBarState();

  final StreamController streamController;
  final double width;
  final double height;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.width, widget.height),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 15),
            child: Row(
              children: <Widget>[
                Text(
                  '${DateFormat.yM().format(DateTime.now())}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ));
  }
}
