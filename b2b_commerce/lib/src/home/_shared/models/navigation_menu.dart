import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// 导航菜单
class NavigationMenu {
  const NavigationMenu(this.item, this.page);

  final BottomNavigationBarItem item;
  final Widget page;
}
