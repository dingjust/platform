import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FilterSelectMenu extends StatefulWidget {
  final StreamController streamController;
  final List<FilterConditionEntry> entries;
  final double height;
  final Color color;
  final Color unselectedColor;
  final ValueChanged<String> afterPressed;
  String filterBarLabel;

  FilterSelectMenu({
    Key key,
    @required this.streamController,
    @required this.entries,
    this.height,
    this.color,
    this.unselectedColor,
    this.afterPressed,
    this.filterBarLabel,
  }) : super(key: key);

  _FilterSelectMenuState createState() => _FilterSelectMenuState();
}

class _FilterSelectMenuState extends State<FilterSelectMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: widget.height,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.entries
              .map((entry) => GestureDetector(
                    onTap: () {
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
                        widget.filterBarLabel = entry.label;
                      });
                      widget.afterPressed(entry.label);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${entry.label}',
                            style: TextStyle(
                                fontSize: 15,
                                color: entry.checked
                                    ? widget.color
                                    : widget.unselectedColor),
                          ),
                          entry.checked
                              ? Icon(
                                  Icons.done,
                                  color: widget.color,
                                  size: 18,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ));
  }
}
