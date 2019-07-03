import 'package:b2b_commerce/b2b_commerce.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:services/src/message/notifications_pool.dart';
import 'package:services/src/message/response/jpush_response.dart';

class JPushService {
  // 工厂模式
  factory JPushService() => _getInstance();

  static JPushService get instance => _getInstance();
  static JPushService _instance;

  JPush _jpush;
  BuildContext _context;

  JPushService._internal() {
    _jpush = JPush();
    // 初始化
    _jpush.addEventHandler(
      // 接收通知回调方法。
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");

        ///更新未读消息数
        notificationsPool$.checkUnread();
      },
      // 点击通知回调方法。
      onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");

        //页面跳转
        onOpenNotification(message);
      },
      // 接收自定义消息回调方法。
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");

        ///更新未读消息数
        notificationsPool$.checkUnread();
      },
    );

    _jpush.setup(
      appKey: GlobalConfigs.JPUSH_APPKEY,
      channel: "developer-default",
      production: true,
      debug: true, // 设置是否打印 debug 日志
    );

    _jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
  }

  static JPushService _getInstance() {
    if (_instance == null) {
      _instance = new JPushService._internal();
    }
    return _instance;
  }

  void onOpenNotification(Map<String, dynamic> message) async {
    if (message != null) {
      debugPrint('notification payload: $message');
      Widget page = pageRoute(message);
      if (page != null) {
        Navigator.push(
          _context,
          new MaterialPageRoute(builder: (context) => page),
        );
      }
    }
  }

  Widget pageRoute(Map<String, dynamic> message) {
    TargetPlatform platform = defaultTargetPlatform;
    platform == TargetPlatform.iOS
        ? pageRouteForIOS(message)
        : pageRouteForAndroid(message);
  }

  ///安卓页面路由
  Widget pageRouteForAndroid(Map<String, dynamic> message) {
    JPushAndroidResponse response = JPushAndroidResponse.fromJson(message);
    switch (PAGE_ROUTE_MAP[response.extras.androidExtras.module]) {
      case 1:
        return QuoteOrderDetailPage(response.extras.androidExtras.params);
        break;
      case 2:
        return ProofingOrderDetailPage(response.extras.androidExtras.params);
      default:
        return null;
    }
  }

  ///IOS页面路由
  Widget pageRouteForIOS(Map<String, dynamic> message) {
    JPushIOSResponse response = JPushIOSResponse.fromJson(message);
    switch (PAGE_ROUTE_MAP[response.module]) {
      case 1:
        return QuoteOrderDetailPage(response.params);
        break;
      case 2:
        return ProofingOrderDetailPage(response.params);
      default:
        return null;
    }
  }

  ///设置context 初始化必须调用
  void setContext(BuildContext context) {
    _context = context;
  }

  ///这是别名，再用户登陆后设置
  void setAlias(String alias) {
    _jpush.setAlias(alias).then((value) {
      print('JPUSH==>setAlias:$value');
    });
  }

  ///删除别名，用户退出后调用
  void deleteAlias() {
    _jpush.deleteAlias().then((map) {
      print('JPUSH==>deleteAlias:$map');
    });
  }

  void getRegistrationID() {
    _jpush.getRegistrationID().then((rid) {
      print('JPUSH==>RegistrationID:$rid');
    });
  }

  void resumePush() {
    _jpush.resumePush();
  }

  void dispose() {
    _jpush.stopPush();
  }
}

var jpush$ = JPushService();

const PAGE_ROUTE_MAP = <MsgModule, int>{
  MsgModule.DEFAULT: 0,
  MsgModule.UserLogin: 0,
  MsgModule.REGISTER: 0,
  MsgModule.QUOTE_NEW: 1,
  MsgModule.QUOTE_REFUSE: 1,
  MsgModule.QUOTE_ADOPTED: 1,
  MsgModule.PROOFING_CREATE: 2,
  MsgModule.PROOFING_DELIVER: 2,
  MsgModule.PROOFING_RECEIVED: 2,
  MsgModule.PURCHASE_DELIVER: 3,
  MsgModule.PURCHASE_RECEIVED: 3
};
