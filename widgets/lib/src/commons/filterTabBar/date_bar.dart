import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class DateBar extends StatefulWidget implements PreferredSizeWidget {
  DateBar({
    Key key,
    @required this.streamController,
    this.width = 200,
    this.height = 10,
    @required this.initeDate,
  }) : super(key: key);

  _DateBarState createState() => _DateBarState();

  final StreamController streamController;
  final double width;
  final double height;

  ///筛选日期
  DateTime initeDate;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _DateBarState extends State<DateBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.width, widget.height),
        child: FlatButton(
          onPressed: () {
            showMonthPicker(context: context, initialDate: widget.initeDate)
                .then((date) => setState(() {
                      if (date != null) {
                        widget.initeDate = date;
                        widget.streamController.add(date);
                      }
                    }));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 0, 0, 15),
            child: Row(
              children: <Widget>[
                Text(
                  '${DateFormat.yM('zh').format(widget.initeDate)}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ));
  }
}
