import 'package:flutter/material.dart';

class FilterBar extends StatefulWidget implements PreferredSizeWidget {
  FilterBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 100,
      this.unselectedColor = Colors.black54,
      this.color =const Color.fromRGBO(255,214,12, 1),
      this.action,
      @required this.onPressed,
      @required this.label,
      this.onCategoryPressed,
      this.categoryLabel})
      : super(key: key);

  _FilterBarState createState() => _FilterBarState();

  double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final Widget action;
  String label;
  String categoryLabel;

  final VoidCallback onCategoryPressed;

  final VoidCallback onPressed;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _FilterBarState extends State<FilterBar> {
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
                  children: <Widget>[
                    FlatButton(
                      onPressed: widget.onCategoryPressed,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color.fromRGBO(255,214,12, 1)),
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.white,
                      child: Text(
                        widget.categoryLabel,
                        style: TextStyle(fontSize: 15, color: Color.fromRGBO(255,214,12, 1)),
                      ),
                    ),
                    Container(
                      width: 118,
                      child: FlatButton(
                          onPressed: widget.onPressed,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.label,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Icon(Icons.keyboard_arrow_down)
                            ],
                          )),
                    )
                  ],
                )),
            widget.action
          ],
        ));
  }
}
