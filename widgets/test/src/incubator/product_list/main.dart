import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: '衣加衣供应链',
    theme: ThemeData(
      // primarySwatch: Colors.blue,
      primaryColor: Colors.white,
      textSelectionColor: Colors.black,
      accentColor: Colors.orangeAccent[400],
      bottomAppBarColor: Colors.grey,
    ),
    home: ProductPage(),
  ));
}

class ProductPage extends StatefulWidget {
  _ProductPageState createState() => _ProductPageState();
  List<int> list = [1, 2, 3, 4, 5, 6, 7, 8];
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        bottom: FilterTabBar(
          entries: <FilterTabEntry>[
            FilterTabEntry(label: '综合', checked: true),
            FilterTabEntry(
              label: '星级',
            ),
            FilterTabEntry(
              label: '接单数',
            ),
            FilterTabEntry(
              label: '响应时间',
            ),
          ],
          action: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
      ),
      body: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          children: widget.list
              .map((value) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.white,
                    child: Center(
                      child: Text(value.toString()),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class FilterTabBar extends StatefulWidget implements PreferredSizeWidget {
  const FilterTabBar(
      {Key key,
      this.itemHeight = 20,
      this.itemWidth = 100,
      @required this.entries,
      this.unselectedColor=Colors.black54,
      this.color = Colors.orange,
      this.action})
      : super(key: key);

  _FilterTabBarState createState() => _FilterTabBarState();

  final List<FilterTabEntry> entries;
  final double itemHeight;
  final double itemWidth;
  final Color unselectedColor;
  final Color color;
  final Widget action;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _FilterTabBarState extends State<FilterTabBar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(widget.itemWidth, widget.itemHeight),
        child: Row(
          children: <Widget>[
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
                              } else {
                                widget.entries.forEach((entry) {
                                  if (entry.checked) {
                                    entry.checked = !entry.checked;
                                  }
                                });
                                entry.checked = !entry.checked;
                              }
                            });
                          },
                          child: Row(
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
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
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

class FilterTabEntry {
  FilterTabEntry(
      {@required this.label,
      this.value,
      this.checked = false,
      this.isDESC = false});

  final String label;
  final String value;
  bool checked;
  bool isDESC;
}
