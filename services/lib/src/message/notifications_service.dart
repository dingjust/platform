import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final String channelId;

  final String channelName;

  final String channelDescription;

  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  BuildContext context;

  NotificationsService(
      {this.channelId = 'nbyjy',
      this.channelName = 'nbyjy',
      this.channelDescription = 'nbyjy'});

  void init(BuildContext context) {
    // 初始化
    this.context = context;
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // 展示通知内容的 dialog.
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(title),
            content: new Text(body),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text('Ok'),
                  onPressed: () async {
                    print('=========消息通知点击事件=============');
                  })
            ],
          ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    //payload 可作为通知的一个标记，区分点击的通知。
    if (payload != null && payload == "complete") {
      print('=========消息通知点击事件=============');
    }
  }

  Future showNotification(int id, String title, String body,
      {String payload}) async {
    // //安卓的通知配置，必填参数是渠道id, 名称, 和描述, 可选填通知的图标，重要度等等。
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '$channelId', '$channelName', '$channelDescription',
        sound: 'slow_spring_board',
        playSound: true,
        enableVibration: true,
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        id, '$title', '$body', platformChannelSpecifics,
        payload: '$payload');
  }
}

var ns$ = NotificationsService();
