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
  final bool multipeSelect;

  FilterSelectMenu({
    Key key,
    @required this.streamController,
    @required this.entries,
    this.height,
    this.color,
    this.unselectedColor,
    this.afterPressed,
    this.filterBarLabel,
    this.multipeSelect = false,
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
                        //多选
                        if (widget.multipeSelect) {
                          //全部
                          if (entry.type == FilterConditionEntryType.ALL) {
                            widget.entries.forEach((entry) {
                              entry.checked = false;
                            });
                            entry.checked = true;
                          } else {
                            widget.entries
                                .firstWhere((entry) =>
                                    entry.type == FilterConditionEntryType.ALL)
                                .checked = false;
                            entry.checked = !entry.checked;
                          }
                          widget.streamController.add(entry);
                        } else {
                          //单选
                          if (entry.checked) {
                            entry.isDESC = !entry.isDESC;
                          } else {
                            widget.entries.forEach((entry) {
                              if (entry.checked) {
                                entry.checked = !entry.checked;
                              }
                            });
                            entry.checked = !entry.checked;
                          }
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
