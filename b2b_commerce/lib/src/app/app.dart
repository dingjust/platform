import 'dart:async';
import 'dart:math';

import 'package:b2b_commerce/src/business/index.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_type_select.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_provider.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/common/privacy_guide_page.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/global_message_helper.dart';
import 'package:b2b_commerce/src/home/_shared/models/navigation_menu.dart';
import 'package:b2b_commerce/src/home/account/client_select_v2.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:b2b_commerce/src/home/index.dart';
import 'package:b2b_commerce/src/home/product/v2/products_page.dart';
import 'package:b2b_commerce/src/my/index.dart';
import 'package:b2b_commerce/src/observer/b2b_navigator_observer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_constants.dart';
import '../common/app_keys.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => globalInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: StreamBuilder<UserModel>(
          initialData: UserBLoC.instance.currentUser,
          stream: UserBLoC.instance.stream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            return B2BApp();
          }),
    );
  }

  ///全局初始化
  void globalInit() {
    // //初始化helpers
    // Provider.of<CertificationStatusHelper>(context)
    // .checkCertificationStatus(context);

    //友盟初始化
    //页面统计
    // UmengPlugin.setPageCollectionModeManual();

    // 预加载全局数据
    AppProvider.preloading(context);
  }
}

///B2B应用
class B2BApp extends StatefulWidget {
  B2BApp({
    Key key,
  }) : super(key: key);

  _B2BAppState createState() => _B2BAppState();
}

class _B2BAppState extends State<B2BApp> with WidgetsBindingObserver {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;

  ///监听登录跳转请求
  StreamSubscription _loginJumpSubscription;

  //跳转登录页限制锁
  bool loginLock = false;

  ///全局Channel-原生通信
  MethodChannel _globalChannel;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => initListener());
    _globalChannel = MethodChannel('net.nbyjy.b2b/global_channel');
    _globalChannel.setMethodCallHandler(_globalChannelMethodHandler);
    super.initState();
  }

  //初始化监听
  void initListener() {
    listenLogin();
    //粘贴板是否有值
    // Provider.of<ClipboardHelper>(context, listen: false)
    //   ..setNavigatorKey(_navigatorKey)
    //   ..getClipboardText(context: context);
    //更新检测
    Future.delayed(Duration(seconds: 3)).then((r) {
      AppVersionHelper appVersionHelper =
          Provider.of<AppVersionHelper>(context, listen: false);
      appVersionHelper.checkVersion(
          context, AppBLoC.instance?.packageInfo?.version, 'nbyjy');
    });
  }

  //监听未登录接口调用跳转登录页
  void listenLogin() {
    _loginJumpSubscription = UserBLoC.instance.loginJumpStream.listen((value) {
      if (!loginLock) {
        loginLock = true;
        BotToast.showText(text: '请登录账号', align: Alignment.center);
        Navigator.of(_navigatorKey.currentState.overlay.context)
            .pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500), //动画时间为500毫秒
                  pageBuilder: (BuildContext context, Animation animation,
                      Animation secondaryAnimation) {
                    return new FadeTransition(
                      //使用渐隐渐入过渡,
                      opacity: animation,
                      child: B2BLoginPage(), //登录页面
                    );
                  },
                ),
                ModalRoute.withName('/'))
            .whenComplete(() {
          loginLock = false;
        });
      }
    });
  }

  /// 处理底部导航
  void _handleNavigation(int index) {
    setState(() {
      if (index != 2) {
        //一键发布
        _currentIndex = index;
      }
    });
  }

  /// 获取导航菜单
  List<NavigationMenu> _getNavigationMenus() {
    List<NavigationMenu> menus = <NavigationMenu>[
      NavigationMenu(
        BottomNavigationBarItem(
          icon: B2BV2Image.tab_1_1(width: 28, height: 28),
          activeIcon: B2BV2Image.tab_1(width: 28, height: 28),
          label: '首页',
        ),
        HomePage(),
      ),
      NavigationMenu(
          BottomNavigationBarItem(
              icon: B2BV2Image.tab_4_1(width: 28, height: 28),
              activeIcon: B2BV2Image.tab_4(width: 28, height: 28),
              label: '看款下单'),
          ProductsPage()),
      // NavigationMenu(
      //   // BottomNavigationBarItem(icon: BottomNotificationsIcon(), label: '消息'),
      //   BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications_none), label: '消息'),
      //   MessagePage(),
      // ),
      NavigationMenu(
          BottomNavigationBarItem(
              label: '一键发布',
              activeIcon: IgnorePointer(
                  child: Opacity(opacity: 0, child: Icon(Icons.nature))),
              icon: IgnorePointer(
                  child: Opacity(opacity: 0, child: Icon(Icons.nature)))),
          RequirementTypeSelectPage()),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: B2BV2Image.tab_2_1(width: 28, height: 28),
            activeIcon: B2BV2Image.tab_2(width: 28, height: 28),
            label: '工作台'),
        BusinessHomePage(),
      ),
      NavigationMenu(
        BottomNavigationBarItem(
            icon: B2BV2Image.tab_3_1(width: 28, height: 28),
            activeIcon: B2BV2Image.tab_3(width: 28, height: 28),
            label: '我的'),
        MyHomePage(),
      ),
    ];
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    final List<NavigationMenu> menus = _getNavigationMenus();
    final botToastBuilder = BotToastInit(); //1.调用BotToastInit

    return //1.使用BotToastInit直接包裹MaterialApp
        MaterialApp(
      navigatorKey: _navigatorKey,
      title: AppConstants.appTitle,
      navigatorObservers: [BotToastNavigatorObserver(), B2BNavigatorObserver()],
      //2.注册路由观察者
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color.fromRGBO(255, 214, 12, 1),
        bottomAppBarColor: Colors.grey,
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          key: AppKeys.appPage,
          body: menus[_currentIndex].page,
          floatingActionButton: _Fab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _handleNavigation,
              items: menus.map((menu) => menu.item).toList(),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedLabelStyle: TextStyle(color: Color(0xff222222)),
              selectedItemColor: Color(0xff222222)),
        );
      }),
      routes: AppRoutes.allRoutes,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate
      ],
      builder: (context, child) {
        child = botToastBuilder(context, child);
        return MaxScaleTextWidget(
          max: 1.0,
          child: child,
        );
      },
      supportedLocales: AppConstants.supportedLocales(),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   //APP状态更改
  //   print('App状态:$state');
  //   if (state == AppLifecycleState.resumed) {
  //     Provider.of<ClipboardHelper>(context, listen: false)
  //         .getClipboardText(context: context);
  //   }
  // }

  ///全局消息处理
  Future _globalChannelMethodHandler(MethodCall methodCall) {
    var message =
        BaseChannelMessage.create(methodCall.method, methodCall.arguments);
    GlobalMessageHelper.handlerChannelMessage(
        message, _navigatorKey.currentState.overlay.context);
    return Future.value();
  }

  @override
  void dispose() {
    super.dispose();
    _loginJumpSubscription.cancel();
    _loginJumpSubscription = null;
    _globalChannel = null;
    WidgetsBinding.instance.removeObserver(this);
  }
}

class _Fab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: defaultTargetPlatform == TargetPlatform.android ? 18 : 16),
      child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RequirementTypeSelectPage()));
          },
          elevation: 0,
          backgroundColor: Colors.white,
          child: B2BV2Image.fab(width: 47, height: 47)),
    );
  }
}

///无身份应用入口
class AnymouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color.fromRGBO(255, 214, 12, 1),
        bottomAppBarColor: Colors.grey,
      ),
      navigatorObservers: [BotToastNavigatorObserver(), B2BNavigatorObserver()],
      home: ClientSelectPageV2(),
      routes: {
        AppRoutes.ROUTE_AUTH_REQUEST_PAGE:
            AppRoutes.allRoutes[AppRoutes.ROUTE_AUTH_REQUEST_PAGE]
      },
      builder: (context, child) {
        final botToastBuilder = BotToastInit(); //1.调用BotToastInit
        child = botToastBuilder(context, child);
        return MaxScaleTextWidget(
          max: 1.0,
          child: child,
        );
      },
    );
  }
}

///隐私政策未授权应用入口
class PrivacyGuideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      navigatorObservers: [BotToastNavigatorObserver(), B2BNavigatorObserver()],
      //2.注册路由观察者
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Color.fromRGBO(255, 214, 12, 1),
        bottomAppBarColor: Colors.grey,
      ),
      routes: AppRoutes.allRoutes,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate
      ],
      home: PrivacyGuidePage(),
      builder: (context, child) {
        final botToastBuilder = BotToastInit(); //1.调用BotToastInit
        child = botToastBuilder(context, child);
        return MaxScaleTextWidget(
          max: 1.0,
          child: child,
        );
      },
      supportedLocales: AppConstants.supportedLocales(),
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
    var scale = min(max, data.textScaleFactor);

    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
