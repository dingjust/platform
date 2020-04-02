import 'package:flutter/material.dart';

class ColorAppbar extends StatelessWidget implements PreferredSizeWidget {
  final double indicatorWeight = 2.0;
  final double _kTabHeight = 46.0;
  final double _kTextAndIconTabHeight = 72.0;
  final TabController tabController;

  final List<Widget> tabs;

  ColorAppbar({Key key, this.tabController, this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TabBar(
            controller: tabController,
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabs,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            isScrollable: true,
            indicatorColor: Color.fromRGBO(255, 214, 12, 1),
          ),
        ),
        Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  // Size get preferredSize => null;
  Size get preferredSize {
    for (Widget item in tabs) {
      if (item is Tab) {
        final Tab tab = item;
        if (tab.text != null && tab.icon != null)
          return Size.fromHeight(_kTextAndIconTabHeight + indicatorWeight);
      }
    }
    return Size.fromHeight(_kTabHeight + indicatorWeight);
  }
}
