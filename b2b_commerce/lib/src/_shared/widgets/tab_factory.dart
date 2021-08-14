import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 默认的Tab Bar
class TabFactory {
  static Widget buildDefaultTabBar(List<EnumModel> tabs,
      {bool scrollable = false, TabController tabController}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: Material(
        color: Colors.white,
        child: TabBar(
          unselectedLabelColor: Color(0xff222222),
          labelColor: Color(0xff222222),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: B2BTabIndicator(
              yPadding: 0,
              borderSide: BorderSide(
                width: 6,
                color: Color(0xffFED800),
              )),
          // indicatorWeight: 4,
          tabs: tabs.map((tab) {
            return Tab(text: tab.name);
          }).toList(),
          labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          isScrollable: scrollable,
          controller: tabController,
        ),
      ),
    );
  }
}
