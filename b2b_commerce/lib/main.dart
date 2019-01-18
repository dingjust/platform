import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/business/index.dart';
import 'src/common/app_bloc.dart';
import 'src/common/app_routes.dart';
import 'src/community/index.dart';
import 'src/home/index.dart';
import 'src/my/index.dart';

void main() {
  debugInstrumentationEnabled = true;

  runApp(BLoCProvider<AppBLoC>(
    bloc: AppBLoC(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  final List<Widget> modules = <Widget>[
    HomePage(),
    ForumHomePage(),
    BusinessHomePage(),
    MyHomePage(),
  ];

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: MaterialApp(
        title: '衣加衣供应链',
        theme: ThemeData(
          // primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          textSelectionColor: Colors.black,
          accentColor: Colors.orangeAccent[400],
          bottomAppBarColor: Colors.grey,
        ),
        home: Scaffold(
          key: const Key('__appPage__'),
          body: widget.modules[_currentIndex],
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
        routes: AppRoutes.allRoutes,
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
      title: const Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.forum),
      title: const Text('广场'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.shopping_cart),
      title: const Text('生意'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_box),
      title: const Text('我的'),
    )
  ];

  void _handleTap(int index) {
    onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
      fixedColor: themeData.accentColor,
    );
  }
}
