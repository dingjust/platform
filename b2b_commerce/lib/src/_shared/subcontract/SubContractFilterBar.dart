import 'package:flutter/material.dart';

class SubContractFilterBar extends StatefulWidget
    implements PreferredSizeWidget {
  SubContractFilterBar({
    Key key,
    this.itemHeight = 20,
    this.itemWidth = 120,
    this.unselectedColor = Colors.black54,
    this.color = const Color.fromRGBO(255, 214, 12, 1),
    this.entries,
    this.horizontalPadding = 0,
  }) : super(key: key);

  _SubContractFilterBarState createState() => _SubContractFilterBarState();

  double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  double horizontalPadding;

  final List<FilterEntry> entries;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _SubContractFilterBarState extends State<SubContractFilterBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(double.infinity, widget.itemHeight),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: widget.entries
                      .map((entry) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                          // width: entry.label == '最新发布' ? 116 : (MediaQuery.of(context).size.width - 116)/3,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  entry.label,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                entry.label == '最新发布' || entry.label.contains('天内')
                                    ? Icon(Icons.keyboard_arrow_down)
                                    : Container(),
                              ],
                            ),
                          )))
                      .toList(),
                )),
          ],
        ));
  }
}

class FilterEntry {
  final String label;

  final VoidCallback onPressed;

  FilterEntry(this.label, this.onPressed);
}
