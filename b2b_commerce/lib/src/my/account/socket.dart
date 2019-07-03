import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:services/services.dart';

class WebSocketRoute extends StatefulWidget {
  @override
  _WebSocketRouteState createState() => new _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  TextEditingController _controller = new TextEditingController();
  String _text = "";
  WebSocket _socket;
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  int count = 1;

  @override
  void initState() {
    // ns$.init(context);
  }

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
            StreamBuilder<int>(
              stream: notificationsPool$.notificationsNumStream,
              initialData: notificationsPool$.notificationsNum,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('${snapshot.data}');
              },
            ),
            RaisedButton(
              onPressed: () async {
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
    super.dispose();
  }
}
