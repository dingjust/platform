import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WebSocketRoute extends StatefulWidget {
  @override
  _WebSocketRouteState createState() => new _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  TextEditingController _controller = new TextEditingController();
  IOWebSocketChannel channel;
  String _text = "";
  WebSocket _socket;
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  int count = 1;

  @override
  void initState() {
    ns$.init(context);

    //创建websocket连接
    // print('===========');
    // print(
    //     'ws://192.168.1.137/message?token=${http$.getToken()}&userId=${UserBLoC.instance.currentUser.mobileNumber}');
    // // channel = new IOWebSocketChannel.connect(
    // //     'ws://192.168.1.137/message?token=${http$.getToken}&userId=${UserBLoC.instance.currentUser.mobileNumber}');

    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = new IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    // var initializationSettings = new InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
  }

  // Future onDidRecieveLocalNotification(
  //     int id, String title, String body, String payload) async {
  //   // 展示通知内容的 dialog.
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) => new CupertinoAlertDialog(
  //           title: new Text(title),
  //           content: new Text(body),
  //           actions: [
  //             CupertinoDialogAction(
  //                 isDefaultAction: true,
  //                 child: new Text('Ok'),
  //                 onPressed: () async {
  //                   print('======================CCCCCCCCCCCCCCCc');
  //                 })
  //           ],
  //         ),
  //   );
  // }

//   Future onSelectNotification(String payload) async {
//     if (payload != null) {
//       debugPrint('notification payload: ' + payload);
//     }
// //payload 可作为通知的一个标记，区分点击的通知。
//     if (payload != null && payload == "complete") {
//       print('===============Click');
//     }
//   }

//   Future _showNotification(int id) async {
//     // //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
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
//         0, 'plain $id', '$id', platformChannelSpecifics,
//         payload: 'item $id');
//   }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("WebSocket(内容回显)"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RaisedButton(
              onPressed: () async {
                ws$.send('asdsa');
                // ns$.showNotification(0, 'title', 'body');
              },
              child: Text('發送'),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
