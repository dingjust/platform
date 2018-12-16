import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'src/cart/index.dart';
import 'src/community/index.dart';
import 'src/home/index.dart';
import 'src/profile/index.dart';

void main() {
  debugInstrumentationEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  List<Widget> _modules;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _modules = <Widget>[
      HomePage(),
      ShoppingCartPage(),
      ForumHomePage(),
      ProfileHomePage(),
    ];

    return MaterialApp(
      title: '衣加衣供应链',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.orangeAccent[400],
      ),
      home: Scaffold(
        body: _modules[_currentIndex],
        bottomNavigationBar: BottomNavigation(
          currentIndex: _currentIndex,
          onChanged: _handleNavigation,
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: '发布需求',
          child: Icon(Icons.add),
          onPressed: null,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key key, this.currentIndex: 0, @required this.onChanged}) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onChanged;

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.home),
      title: const Text("主页"),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_cart),
      title: const Text("购物车"),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.forum),
      title: const Text("社区"),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_box),
      title: const Text("我的"),
    )
  ];

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
    );
  }
}
