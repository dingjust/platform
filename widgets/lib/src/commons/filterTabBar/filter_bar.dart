import 'package:flutter/material.dart';
import 'package:models/models.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  FilterBar({
    Key key,
    this.itemHeight = 20,
    this.itemWidth = 100,
    this.unselectedColor = Colors.black54,
    this.color = const Color.fromRGBO(255, 214, 12, 1),
    this.action,
    @required this.onChanged,
    @required this.filterConditionEntries,
  }) : super(key: key);

  _FilterBarState createState() => _FilterBarState();

  final double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final List<Widget> action;
  final List<FilterConditionEntry> filterConditionEntries;

  final ValueChanged<FilterConditionEntry> onChanged;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _FilterBarState extends State<FilterBar> {
  void _handleTap(FilterConditionEntry condition) {
    widget.onChanged(condition);
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.filterConditionEntries
                      .map((condition) => Container(
                            child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    widget.filterConditionEntries
                                        .forEach((condition) {
                                      condition.checked = false;
                                    });
                                    condition.checked = true;
                                    _handleTap(condition);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${condition.label}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: condition.checked
                                              ? Color.fromRGBO(255, 219, 0, 1)
                                              : Colors.black),
                                    ),
                                    condition.checked
                                        ? Icon(
                                            Icons.keyboard_arrow_down,
                                            color:
                                                Color.fromRGBO(255, 219, 0, 1),
                                          )
                                        : Icon(null)
                                  ],
                                )),
                          ))
                      .toList(),
                )),
            Row(
              children: widget.action,
            )
          ],
        ));
  }
}

class RequirementFilterBar extends StatefulWidget
    implements PreferredSizeWidget {
  RequirementFilterBar({
    Key key,
    this.itemHeight = 20,
    this.itemWidth = 100,
    this.unselectedColor = Colors.black54,
    this.color = const Color.fromRGBO(255, 214, 12, 1),
    this.action,
    this.entries,
  }) : super(key: key);

  _RequirementFilterBarState createState() => _RequirementFilterBarState();

  double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final Widget action;

  final List<FilterEntry> entries;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _RequirementFilterBarState extends State<RequirementFilterBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.entries
                      .map((entry) => Container(
                            child: FlatButton(
                                onPressed: entry.onPressed,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      entry.label,
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    entry.label == '最新发布'
                                        ? Icon(Icons.keyboard_arrow_down)
                                        : Container()
                                  ],
                                )),
                          ))
                      .toList(),
                )),
            widget.action
          ],
        ));
  }
}

class FilterEntry {
  final String label;

  final VoidCallback onPressed;

  FilterEntry(this.label, this.onPressed);
}
