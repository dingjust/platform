import 'package:b2b_commerce/src/common/app_constants.dart';
import 'package:b2b_commerce/src/home/_shared/models/navigation_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgets/widgets.dart';

import '../business/index_brand.dart';
import '../business/orders/requirement_order_from.dart';
import '../common/app_keys.dart';
import '../common/app_routes.dart';
import '../home/index_brand.dart';
import '../home/navigation/bottom_navigation.dart';
import '../my/index.dart';
import '../production/index.dart';

class BrandClient extends StatefulWidget {
  BrandClient({Key key}) : super(key: key);

  final List<NavigationMenu> menus = <NavigationMenu>[
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(B2BIcons.home),
        ),
        activeIcon: Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(B2BIcons.home_active),
        ),
        title: const Text('商机'),
      ),
      page: BrandHomePage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: const EdgeInsets.only(right: 35),
          child: const Icon(B2BIcons.production),
        ),
        activeIcon: Container(
          margin: const EdgeInsets.only(right: 35),
          child: const Icon(B2BIcons.production_active),
        ),
        title: Container(
          margin: const EdgeInsets.only(right: 30),
          child: const Text('生产'),
        ),
      ),
      page: ProductionPage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(left: 35),
            child: const Icon(B2BIcons.business),
          ),
          activeIcon: Container(
            margin: const EdgeInsets.only(left: 35),
            child: const Icon(B2BIcons.business_active),
          ),
          title: Container(
            margin: const EdgeInsets.only(left: 45),
            child: const Text('工作'),
          )),
      page: BrandBusinessHomePage(),
    ),
    NavigationMenu(
      item: BottomNavigationBarItem(
        icon: Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(
            B2BIcons.my,
          ),
        ),
        activeIcon: Container(
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(
            B2BIcons.my_active,
          ),
        ),
        title: const Text('我的'),
      ),
      page: MyHomePage(),
    ),
  ];

  _BrandClientState createState() => _BrandClientState();
}

class _BrandClientState extends State<BrandClient> {
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onPublish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(),
      ),
    );
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
              floatingActionButton: PublishRequirementButton(
                onPublish: () => _onPublish(context),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class PublishRequirementButton extends StatelessWidget {
  const PublishRequirementButton({
    Key key,
    @required this.onPublish,
  }) : super(key: key);

  final Function onPublish;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      tooltip: '发布需求',
      child: Icon(
        Icons.add,
        color: Colors.black,
        size: 45,
      ),
      onPressed: onPublish,
    );
  }
}
