import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 底部导航
class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    Key key,
    this.currentIndex: 0,
    @required this.onChanged,
    @required this.items,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onChanged;
  final List<BottomNavigationBarItem> items;

  void _handleTap(int index) {
    onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
      fixedColor: Color.fromRGBO(51, 51, 51, 1),
    );
  }
}
