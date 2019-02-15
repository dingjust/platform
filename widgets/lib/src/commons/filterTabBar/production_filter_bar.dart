import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductionFilterBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ProductionFilterBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 100,
      @required this.entries,
      this.unselectedColor = Colors.black54,
      this.color = Colors.orange,
      @required this.streamController,
      @required this.action,
      @required this.leading})
      : super(key: key);

  _ProductionFilterBarState createState() => _ProductionFilterBarState();

  final List<FilterConditionEntry> entries;
  final double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final Widget leading;
  final Widget action;
  final StreamController streamController;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _ProductionFilterBarState extends State<ProductionFilterBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Row(
          children: <Widget>[
            widget.leading,
            Expanded(
                child: Container(
              height: widget.itemHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.entries
                    .map((entry) => FlatButton(
                          onPressed: () {
                            setState(() {
                              if (entry.checked) {
                                entry.isDESC = !entry.isDESC;
                                //stream通知状态更改
                                widget.streamController.add(entry);
                              } else {
                                widget.entries.forEach((entry) {
                                  if (entry.checked) {
                                    entry.checked = !entry.checked;
                                  }
                                });
                                entry.checked = !entry.checked;
                                //stream通知状态更改
                                widget.streamController.add(entry);
                              }
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${entry.label}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: entry.checked
                                        ? widget.color
                                        : widget.unselectedColor),
                              ),
                              Icon(
                                entry.isDESC
                                    ? Icons.arrow_drop_down
                                    : Icons.arrow_drop_up,
                                color: entry.checked
                                    ? widget.color
                                    : widget.unselectedColor,
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )),
            widget.action
          ],
        ));
  }
}
