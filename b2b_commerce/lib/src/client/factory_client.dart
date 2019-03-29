import 'package:b2b_commerce/src/common/app_constants.dart';
import 'package:b2b_commerce/src/home/_shared/models/navigation_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgets/widgets.dart';

import '../business/index_factory.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';
import '../home/index_factory.dart';
import '../home/navigation/bottom_navigation.dart';
import '../my/index.dart';
import '../production/index.dart';

class FactoryClient extends StatefulWidget {
  FactoryClient({Key key}) : super(key: key);

  final List<NavigationMenu> menus = <NavigationMenu>[
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(right: 12),
          child: const Icon(B2BIcons.home),
        ),
        activeIcon: Container(
          margin: EdgeInsets.only(right: 12),
          child: const Icon(
            B2BIcons.home_active,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text('商机'),
      ),
      page: FactoryHomePage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(right: 15),
          child: const Icon(B2BIcons.production),
        ),
        activeIcon: Container(
          margin: EdgeInsets.only(right: 15),
          child: const Icon(B2BIcons.production_active),
        ),
        title: const Text('生产'),
      ),
      page: ProductionPage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(right: 10),
          child: const Icon(B2BIcons.business),
        ),
        activeIcon: Container(
          margin: EdgeInsets.only(right: 10),
          child: const Icon(B2BIcons.business_active),
        ),
        title: const Text('工作'),
      ),
      page: FactoryBusinessHomePage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: EdgeInsets.only(right: 10),
          child: const Icon(B2BIcons.my),
        ),
        activeIcon: Container(
          margin: EdgeInsets.only(right: 10),
          child: const Icon(B2BIcons.my_active),
        ),
        title: const Text('我的'),
      ),
      page: MyHomePage(),
    ),
  ];

  _FactoryClientState createState() => _FactoryClientState();
}

class _FactoryClientState extends State<FactoryClient> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        textSelectionColor: Colors.black,
        accentColor: Color.fromRGBO(255, 214, 12, 1),
        bottomAppBarColor: Colors.grey,
      ),
      home: Builder(
        builder: (context) => Scaffold(
              key: AppKeys.appPage,
              body: widget.menus[_currentIndex].page,
              bottomNavigationBar: BottomNavigation(
                currentIndex: _currentIndex,
                onChanged: _handleNavigation,
                items: widget.menus.map((menu) => menu.item).toList(),
              ),
            ),
      ),
      routes: AppRoutes.allRoutes,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLocales,
    );
  }
}
