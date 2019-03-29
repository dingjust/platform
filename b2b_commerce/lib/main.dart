import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/home/_shared/widgets/bottom_navigation.dart';
import 'src/business/index_brand.dart';
import 'src/business/index_factory.dart';
import 'src/business/orders/requirement_order_from.dart';
import 'src/common/app_bloc.dart';
import 'src/common/app_constants.dart';
import 'src/common/app_keys.dart';
import 'src/common/app_routes.dart';
import 'src/home/_shared/models/navigation_menu.dart';
import 'src/home/account/login.dart';
import 'src/home/index.dart';
import 'src/my/index.dart';
import 'src/production/index.dart';

void main() async {
  debugInstrumentationEnabled = true;

  // 初始化,检测是否有用户登陆信息
  await UserBLoC.instance.checkLocalUser();

  runApp(BLoCProvider<AppBLoC>(
    bloc: AppBLoC(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: StreamBuilder<UserModel>(
          initialData: UserBLoC.instance.currentUser,
          stream: UserBLoC.instance.stream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            // 未登陆
            if (snapshot.data.type == UserType.ANONYMOUS) {
              return MaterialApp(
                home: B2BLoginPage(),
              );
            }

            return MyAppHomeDelegate(userType: snapshot.data.type);
          }),
    );
  }
}

class MyAppHomeDelegate extends StatefulWidget {
  MyAppHomeDelegate({Key key, @required this.userType}) : super(key: key);

  final UserType userType;

  _MyAppHomeDelegateState createState() => _MyAppHomeDelegateState();
}

class _MyAppHomeDelegateState extends State<MyAppHomeDelegate> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  /// 处理底部导航
  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => listenMessage());
  }

  //异常消息dialog
  void listenMessage() {
    MessageBLoC.instance.errorMessageStream.listen((value) {
      final appContext = _navigatorKey.currentState.overlay.context;
      final dialog = AlertDialog(
        content: Text('$value'),
      );
      showDialog(context: appContext, builder: (x) => dialog);
    });
  }

  /// 发布需求
  void _onPublish(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(),
      ),
    );
  }

  bool _isBrand() {
    return widget.userType == UserType.BRAND;
  }

  /// 获取导航菜单
  List<NavigationMenu> _getNavigationMenus() {
    List<NavigationMenu> menus;

    if (widget.userType == UserType.BRAND) {
      menus = <NavigationMenu>[
        NavigationMenu(
          BottomNavigationBarItem(
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
          HomePage(userType: UserType.BRAND),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          ProductionPage(),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          BrandBusinessHomePage(),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          MyHomePage(),
        ),
      ];
    }

    if (widget.userType == UserType.FACTORY) {
      return <NavigationMenu>[
        NavigationMenu(
          BottomNavigationBarItem(
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
          HomePage(userType: UserType.FACTORY),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          ProductionPage(),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          FactoryBusinessHomePage(),
        ),
        NavigationMenu(
          BottomNavigationBarItem(
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
          MyHomePage(),
        ),
      ];
    }

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationMenu> menus = _getNavigationMenus();

    return MaterialApp(
      navigatorKey: _navigatorKey,
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
              body: menus[_currentIndex].page,
              bottomNavigationBar: BottomNavigation(
                currentIndex: _currentIndex,
                onChanged: _handleNavigation,
                items: menus.map((menu) => menu.item).toList(),
              ),
              floatingActionButton: _isBrand()
                  ? PublishRequirementButton(
                      onPublish: () => _onPublish(context),
                    )
                  : null,
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

/// 发布需求按钮
class PublishRequirementButton extends StatelessWidget {
  const PublishRequirementButton({
    Key key,
    @required this.onPublish,
  }) : super(key: key);

  final VoidCallback onPublish;

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
