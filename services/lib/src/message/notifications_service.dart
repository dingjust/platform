// import 'dart:convert';

// import 'package:b2b_commerce/b2b_commerce.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:services/src/message/jpush_service.dart';
// import 'package:services/src/websocket/websocket_response.dart';

// class NotificationsService {
//   final String channelId;

//   final String channelName;

//   final String channelDescription;

//   var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   BuildContext context;

//   NotificationsService({this.channelId = 'nbyjy',
//     this.channelName = 'nbyjy',
//     this.channelDescription = 'nbyjy'});

//   void init(BuildContext context) {
//     // 初始化
//     this.context = context;
//     var initializationSettingsAndroid =
//     new AndroidInitializationSettings('logo');
//     var initializationSettingsIOS = new IOSInitializationSettings(
//         onDidReceiveLocalNotification: onDidRecieveLocalNotification);
//     var initializationSettings = new InitializationSettings(
//         initializationSettingsAndroid, initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   Future onDidRecieveLocalNotification(int id, String title, String body, String payload) async {
//     // 展示通知内容的 dialog.
//     showDialog(
//       context: context,
//       builder: (BuildContext context) => new CupertinoAlertDialog(
//         title: new Text(title),
//         content: new Text(body),
//         actions: [
//           CupertinoDialogAction(
//               isDefaultAction: true,
//               child: new Text('Ok'),
//               onPressed: () async {
//                 print('=========消息通知点击事件=============');
//               })
//         ],
//       ),
//     );
//   }

//   Future onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
//     // await Navigator.push(
//     //   context,
//     //   new MaterialPageRoute(
//     //       builder: (context) => ProofingOrderDetailPage('111')),
//     // );

//     Widget page = pageRoute(payload);
//     if (page != null) {
//       Navigator.push(
//         context,
//         new MaterialPageRoute(builder: (context) => page),
//       );
//     }
//   }

//   Future showNotification(int id, String title, String body,
//       {String payload}) async {
//     // //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         '$channelId', '$channelName', '$channelDescription',
//         sound: 'slow_spring_board',
//         playSound: true,
//         enableVibration: true,
//         importance: Importance.Max,
//         priority: Priority.High,
//         ticker: 'ticker');
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//     await flutterLocalNotificationsPlugin.show(
//         id, '$title', '$body', platformChannelSpecifics,
//         payload: payload);
//   }

//   Widget pageRoute(String payload) {
//     WebsocketResponse response = WebsocketResponse.fromJson(
//         json.decode(payload) as Map<String, dynamic>);

//     switch (PAGE_ROUTE_MAP[response.module]) {
//       case 1:
//         return QuoteOrderDetailPage(response.params);
//         break;
//       case 2:
//         return ProofingOrderDetailPage(response.params);
//       default:
//         return null;
//     }
//   }
// }

// var ns$ = NotificationsService();

// // const PAGE_ROUTE_MAP = <MsgModule, int>{
// //   MsgModule.DEFAULT: 0,
// //   MsgModule.UserLogin: 0,
// //   MsgModule.REGISTER: 0,
// //   MsgModule.QUOTE_NEW: 1,
// //   MsgModule.QUOTE_REFUSE: 1,
// //   MsgModule.QUOTE_ADOPTED: 1,
// //   MsgModule.PROOFING_CREATE: 2,
// //   MsgModule.PROOFING_DELIVER: 2,
// //   MsgModule.PROOFING_RECEIVED: 2,
// //   MsgModule.PURCHASE_DELIVER: 3,
// //   MsgModule.PURCHASE_RECEIVED: 3
// // };
