import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 默认的Tab Bar
class TabFactory {
  static Widget buildDefaultTabBar(List<EnumModel> tabs) {
    return TabBar(
      unselectedLabelColor: Colors.black26,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: tabs.map((tab) {
        return Tab(text: tab.name);
      }).toList(),
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      isScrollable: false,
    );
  }
}
