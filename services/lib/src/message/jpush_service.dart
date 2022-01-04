// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:b2b_commerce/b2b_commerce.dart';
// import 'package:core/core.dart';

// import 'package:jpush_flutter/jpush_flutter.dart';
// import 'package:models/models.dart';
// import 'package:services/services.dart';
// import 'package:services/src/message/notifications_pool.dart';
// import 'package:services/src/message/response/jpush_response.dart';

// class JPushService {
//   // 工厂模式
//   factory JPushService() => _getInstance();

//   static JPushService get instance => _getInstance();
//   static JPushService _instance;

//   JPush _jpush;
//   BuildContext _context;

//   JPushService._internal() {
//     _jpush = JPush();
//     try {
//       // 初始化
//       _jpush.addEventHandler(
//         // 接收通知回调方法。
//         onReceiveNotification: (Map<String, dynamic> message) async {
//           print("flutter onReceiveNotification: $message");

//           ///更新未读消息数
//           notificationsPool$.checkUnread();

//           ///是否生产消息
//           notificationsPool$.analysProductionMessage(message);
//         },
//         // 点击通知回调方法。
//         onOpenNotification: (Map<String, dynamic> message) async {
//           print("flutter onOpenNotification: $message");

//           //页面跳转
//           onOpenNotification(message);
//         },
//         // 接收自定义消息回调方法。
//         onReceiveMessage: (Map<String, dynamic> message) async {
//           print("flutter onReceiveMessage: $message");

//           ///更新未读消息数
//           notificationsPool$.checkUnread();
//         },
//       );
//     } on PlatformException {
//       print('[JPush]Failed to get platform version');
//     }
//     _jpush.setup(
//       appKey: GlobalConfigs.JPUSH_APPKEY,
//       channel: "developer-default",
//       production: true,
//       debug: true, // 设置是否打印 debug 日志
//     );
//     print('JPUSH初始化====================');

//     _jpush.applyPushAuthority(
//         new NotificationSettingsIOS(sound: true, alert: true, badge: true));
//   }

//   static JPushService _getInstance() {
//     if (_instance == null) {
//       _instance = new JPushService._internal();
//     }
//     return _instance;
//   }

//   //发送本地推送
//   Future<String> sendLocalNotification(LocalNotification localNotification) {
//     return _jpush.sendLocalNotification(localNotification);
//   }

//   void onOpenMessage(NotifyModel message, BuildContext context) async {
//     if (message != null) {
//       Widget page = pageRouteForMessageModel(message);
//       if (page != null) {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => page),
//         );
//       }
//     }
//   }

//   void onOpenNotification(Map<String, dynamic> message) async {
//     if (message != null) {
//       debugPrint('notification payload: $message');
//       Widget page = pageRoute(message);
//       if (page != null) {
//         Navigator.push(
//           _context,
//           new MaterialPageRoute(builder: (context) => page),
//         );
//       }
//     }
//   }

//   Widget pageRoute(Map<String, dynamic> message) {
//     TargetPlatform platform = defaultTargetPlatform;
//     return platform == TargetPlatform.iOS
//         ? pageRouteForIOS(message)
//         : pageRouteForAndroid(message);
//   }

//   ///安卓页面路由
//   Widget pageRouteForAndroid(Map<String, dynamic> message) {
//     JPushAndroidResponse response = JPushAndroidResponse.fromJson(message);
//     switch (PAGE_ROUTE_MAP[response.extras.androidExtras.module]) {
//       case 1:
//         return QuoteOrderDetailPage(response.extras.androidExtras.params);
//         break;
//       case 4:
//         return UserBLoC.instance.currentUser.type == UserType.FACTORY
//             ? RequirementOrderDetailByFactoryPage(
//                 response.extras.androidExtras.params)
//             : RequirementOrderDetailPage(response.extras.androidExtras.params);
//       case 5:
//         return SaleOrderDetailPage(code: response.extras.androidExtras.params);
//       default:
//         return null;
//     }
//   }

//   ///IOS页面路由
//   Widget pageRouteForIOS(Map<String, dynamic> message) {
//     JPushIOSResponse response = JPushIOSResponse.fromJson(message);
//     switch (PAGE_ROUTE_MAP[response.module]) {
//       case 1:
//         return QuoteOrderDetailPage(response.params);
//         break;
//       case 4:
//         return UserBLoC.instance.currentUser.type == UserType.FACTORY
//             ? RequirementOrderDetailByFactoryPage(response.params)
//             : RequirementOrderDetailPage(response.params);
//       case 5:
//         return SaleOrderDetailPage(code: response.params);
//       default:
//         return null;
//     }
//   }

//   ///消息管理页面路由
//   Widget pageRouteForMessageModel(NotifyModel message) {
//     switch (PAGE_ROUTE_MAP[message.moduleCode]) {
//       case 1:
//         return QuoteOrderDetailPage(message.params);
//         break;
//       case 4:
//         return UserBLoC.instance.currentUser.type == UserType.FACTORY
//             ? RequirementOrderDetailByFactoryPage(message.params)
//             : RequirementOrderDetailPage(message.params);
//       case 5:
//         return SaleOrderDetailPage(code: message.params);
//       default:
//         return null;
//     }
//   }

//   ///设置context 初始化必须调用
//   void setContext(BuildContext context) {
//     _context = context;
//   }

//   ///这是别名，再用户登录后设置
//   void setAlias(String alias) {
//     try {
//       _jpush.setAlias(alias).then((value) {
//         print('JPUSH==>setAlias:$value');
//       });
//     } catch (e) {
//       print('JPUSH==>ERROR:setAlias');
//     }
//   }

//   ///删除别名，用户退出后调用
//   void deleteAlias() {
//     _jpush.deleteAlias().then((map) {
//       print('JPUSH==>deleteAlias:$map');
//     });
//   }

//   void getRegistrationID() {
//     _jpush.getRegistrationID().then((rid) {
//       print('JPUSH==>RegistrationID:$rid');
//     });
//   }

//   void resumePush() {
//     _jpush.resumePush();
//   }

//   void dispose() {
//     _jpush.stopPush();
//   }
// }

// var jpush$ = JPushService();

// const PAGE_ROUTE_MAP = <MsgModule, int>{
//   MsgModule.DEFAULT: 0,
//   MsgModule.UserLogin: 0,
//   MsgModule.REGISTER: 0,
//   MsgModule.QUOTE_NEW: 1,
//   MsgModule.QUOTE_REFUSE: 1,
//   MsgModule.QUOTE_ADOPTED: 1,
//   MsgModule.PROOFING_CREATE: 2,
//   MsgModule.PROOFING_DELIVER: 2,
//   MsgModule.PROOFING_RECEIVED: 2,
//   MsgModule.PROOFING_PAY: 2,
//   MsgModule.PURCHASE_DELIVER: 3,
//   MsgModule.PURCHASE_RECEIVED: 3,
//   MsgModule.NEW_PURCHASE_ORDER: 3,
//   MsgModule.PROGRESS_UPDATED: 3,
//   MsgModule.PAY_DEPOSIT: 3,
//   MsgModule.PAY_THE_REST: 3,
//   MsgModule.PURCHASE_FACTORY_DELAY: 3,
//   MsgModule.PURCHASE_BRAND_DELAY: 3,
//   MsgModule.RECOMMEND_REQUIRE_ORDER: 4,
//   MsgModule.SALES_ORDER_DELIVERY_REMINDER: 5,
// };
