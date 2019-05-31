import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/business/index.dart';
import 'package:b2b_commerce/src/home/account/client_select.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/business/orders/requirement_order_from.dart';
import 'src/common/app_bloc.dart';
import 'src/common/app_constants.dart';
import 'src/common/app_keys.dart';
import 'src/common/app_routes.dart';
import 'src/home/_shared/models/navigation_menu.dart';
import 'src/home/_shared/widgets/bottom_navigation.dart';
import 'src/home/account/login.dart';
import 'src/home/index.dart';
import 'src/my/index.dart';
import 'src/production/index.dart';

void main() async {
  debugInstrumentationEnabled = true;

  // 初始化,检测是否有用户登录信息
  await UserBLoC.instance.checkLocalUser();

  //头部状态栏阴影
  TargetPlatform platform = defaultTargetPlatform;
  if (platform != TargetPlatform.iOS) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else {
    //IOS高德定位注册KEY
    AMapLocationClient.setApiKey(GlobalConfigs.AMAP_LOCATION_KEY_IOS);
  }

  //强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(BLoCProvider<AppBLoC>(
      bloc: AppBLoC.instance,
      child: MyApp(),
    ));
  });
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
            // 未登录
            if (snapshot.data.type == UserType.ANONYMOUS) {
              return MaterialApp(
                home: ClientSelectPage(),
                builder: (ctx, w) {
                  return MaxScaleTextWidget(
                    max: 1.0,
                    child: w,
                  );
                },
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
  RequirementOrderModel requirementOrderModel;

  /// 处理底部导航
  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) => initListener());
    super.initState();
  }

  //初始化监听
  void initListener() {
    listenMessage();
    listenLogin();
  }

  //监听异常消息,dialog
  void listenMessage() {
    MessageBLoC.instance.errorMessageStream.listen((value) {
      final appContext = _navigatorKey.currentState.overlay.context;
      final dialog = AlertDialog(
        content: Text('$value'),
      );
      showDialog(context: appContext, builder: (x) => dialog);
    });
  }

  //监听未登录接口调用跳转登录页
  void listenLogin() {
    UserBLoC.instance.loginJumpStream.listen((value) {
      if (true) {
        Navigator.of(_navigatorKey.currentState.overlay.context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => B2BLoginPage()),
                ModalRoute.withName('/'));
      }
    });
  }

  /// 发布需求
  void _onPublish(BuildContext context) async {
    requirementOrderModel =
        RequirementOrderModel(details: RequirementInfoModel(), attachments: []);
    RequirementOrderModel model = await RequirementOrderRepository()
        .getRequirementOrderDetail('TRO00021002');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RequirementOrderFrom(
              isCreate: true,
              order: requirementOrderModel,
            ),
      ),
    );
  }

  bool _isBrand() {
    return UserBLoC.instance.currentUser.type == UserType.BRAND;
  }

  /// 获取导航菜单
  List<NavigationMenu> _getNavigationMenus() {
    List<NavigationMenu> menus = <NavigationMenu>[
      NavigationMenu(
        BottomNavigationBarItem(
          icon: Container(
            child: const Icon(B2BIcons.home),
          ),
          activeIcon: Container(
            child: const Icon(B2BIcons.home_active),
          ),
          title: const Text('商机'),
        ),
        HomePage(userType: widget.userType),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
          icon: Container(
            margin: EdgeInsets.only(right: _isBrand() ? 35 : 10),
            child: const Icon(B2BIcons.production),
          ),
          activeIcon: Container(
            margin: EdgeInsets.only(right: _isBrand() ? 35 : 10),
            child: const Icon(B2BIcons.production_active),
          ),
          title: Container(
            margin: EdgeInsets.only(right: _isBrand() ? 35 : 0),
            child: const Text('生产'),
          ),
        ),
        ProductionPage(),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(left: _isBrand() ? 35 : 0),
              child: const Icon(B2BIcons.business),
            ),
            activeIcon: Container(
              margin: EdgeInsets.only(left: _isBrand() ? 35 : 0),
              child: const Icon(B2BIcons.business_active),
            ),
            title: Container(
              margin: EdgeInsets.only(left: _isBrand() ? 40 : 0),
              child: const Text('工作'),
            )),
        BusinessHomePage(userType: widget.userType),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(right: 10),
              child: const Icon(
                B2BIcons.my,
              ),
            ),
            activeIcon: Container(
              margin: EdgeInsets.only(right: 10),
              child: const Icon(
                B2BIcons.my_active,
              ),
            ),
            title: Container(
              margin: EdgeInsets.only(right: 10),
              child: const Text('我的'),
            )),
        MyHomePage(),
      ),
    ];

    return menus;
  }

  @override
  Widget build(BuildContext context) {
    print('===================Build${widget.userType}');

    final List<NavigationMenu> menus = _getNavigationMenus();

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appTitle,
      theme: ThemeData(
        primaryColor: Colors.white,
        // textSelectionColor: Colors.black,
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
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
        ),
      ),
      routes: AppRoutes.allRoutes,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate
      ],
      builder: (ctx, w) {
        return MaxScaleTextWidget(
          max: 1.0,
          child: w,
        );
      },
      supportedLocales: AppConstants.supportedLocales(),
    );
  }
}

/// 发布需求按钮·
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

class MaxScaleTextWidget extends StatelessWidget {
  final double max;
  final Widget child;

  const MaxScaleTextWidget({
    Key key,
    this.max = 1.0,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return MediaQuery(
      data: data.copyWith(
          textScaleFactor:
          max > data.textScaleFactor ? data.textScaleFactor : max),
      child: child,
    );
  }
}
