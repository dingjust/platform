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
      @required this.leading,
      this.height = 40,
      this.indicatorWidth = 20,
      this.indicatorHeight = 2})
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
  final double indicatorWidth;
  final double indicatorHeight;
  final double height;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _ProductionFilterBarState extends State<ProductionFilterBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildBody(),
          ),
        ));
  }

  List<Widget> _buildBody() {
    List<Widget> body = [widget.leading];
    body.addAll(widget.entries
        .map((entry) => FlatButton(
              onPressed: () {
                setState(() {
                  widget.entries.forEach((entry) {
                    if (entry.checked) {
                      entry.checked = !entry.checked;
                    }
                  });
                  entry.checked = !entry.checked;
                  //stream通知状态更改
                  widget.streamController.add(entry);
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${entry.label}',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: entry.checked
                            ? widget.color
                            : widget.unselectedColor),
                  ),
                  entry.checked
                      ? Container(
                          height: widget.indicatorHeight,
                          width: widget.indicatorWidth,
                          margin: EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: BorderRadius.circular(2)),
                        )
                      : Container(
                          height: widget.indicatorHeight,
                          width: widget.indicatorWidth,
                          margin: EdgeInsets.only(top: 3),
                        )
                ],
              ),
            ))
        .toList());
    body.add(widget.action);
    return body;
  }
}
