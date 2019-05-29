import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ProductionFilterBar extends StatefulWidget
    implements PreferredSizeWidget {
  const ProductionFilterBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 75,
      @required this.entries,
      this.unselectedColor = Colors.black54,
      this.color = Colors.black,
      @required this.streamController,
      @required this.action,
      @required this.leading,
      this.height = 55,
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
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _buildBody(),
                ),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildBody() {
    //头部Icon
    // List<Widget> body = [widget.leading];
    List<Widget> body = [];
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
                  ProductionBLoC().setStatus(entry.value);
                  ProductionBLoC().clear();
                  ProductionBLoC().getData('');
                  //stream通知状态更改
                  widget.streamController.add(entry);
                });
              },
              child: Container(
                width: widget.itemWidth,
                height: widget.height,
                child: Stack(
                  // fit: StackFit.expand,
                  children: <Widget>[
                    Positioned(
                      left: 0,
                      top: 12,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${entry.label}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                      entry.checked ? FontWeight.bold : null,
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
                                        color: Color.fromRGBO(255, 214, 12, 1),
                                        borderRadius: BorderRadius.circular(2)),
                                  )
                                : Container(
                                    height: widget.indicatorHeight,
                                    width: widget.indicatorWidth,
                                    margin: EdgeInsets.only(top: 3),
                                  )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 1,
                      child: entry.onRemind
                          ? Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 38, 38, 0.8),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  '${entry.remindNum}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            )
                          : Container(
                              width: 20,
                              height: 20,
                            ),
                    )
                  ],
                ),
              ),
            ))
        .toList());
    // body.add();

    return body;
  }
}
