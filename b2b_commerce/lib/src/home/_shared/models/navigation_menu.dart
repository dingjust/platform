import 'package:flutter/widgets.dart';

/// 导航菜单
class NavigationMenu {
  const NavigationMenu(this.item, this.page);

  final BottomNavigationBarItem item;
  final Widget page;
}
