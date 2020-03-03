import 'package:flutter/material.dart';
import 'package:models/models.dart';

class IndexSearchBar extends StatefulWidget implements PreferredSizeWidget {
  IndexSearchBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 100,
      @required this.entries,
      this.unselectedColor = Colors.black54,
      this.color = Colors.black,
      this.height = 55,
      this.indicatorWidth = 50,
      this.value,
      this.indicatorHeight = 2})
      : super(key: key);

  _IndexSearchBarState createState() => _IndexSearchBarState();

  final List<FilterConditionEntry> entries;
  final double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final double indicatorWidth;
  final double indicatorHeight;
  final double height;
  String value;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}

class _IndexSearchBarState extends State<IndexSearchBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _buildBody()),
        ));
  }

  List<Widget> _buildBody() {
    //头部Icon
    // List<Widget> body = [widget.leading];
    List<Widget> body = [];
    body.addAll(widget.entries
        .map((entry) =>
        Expanded(
          flex: 1,
          child: FlatButton(
            onPressed: () {
              setState(() {
                widget.entries.forEach((entry) {
                  if (entry.checked) {
                    entry.checked = !entry.checked;
                  }
                });
                entry.checked = !entry.checked;
              });
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${entry.label}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: entry.checked ? FontWeight.bold : null,
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
            ))
        .toList());
    // body.add();

    return body;
  }
}
