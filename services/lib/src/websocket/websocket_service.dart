import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:services/src/message/notifications_pool.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/bloc/user_bloc.dart';
import 'package:services/src/websocket/websocket_response.dart';

class WebSocketService {
  // 工厂模式
  factory WebSocketService() => _getInstance();

  static WebSocketService get instance => _getInstance();
  static WebSocketService _instance;

  WebSocket _socket;
  Timer _timer;

  ///心跳间隔
  Duration _duration = Duration(seconds: GlobalConfigs.HEARTBEAT_DURATION);

  WebSocketService._internal() {
    // 初始化
    _tryConnect();
    _heartbeat();
  }

  static WebSocketService _getInstance() {
    if (_instance == null) {
      _instance = new WebSocketService._internal();
    }
    return _instance;
  }

  void _onDisconnected() {
    print('========Socket连接中断=========');
    print(
        'Disconnected    ws:${this.hashCode}  ----  socket:${_socket
            .hashCode}');
    if (_socket != null) {
      _socket.close();
    }
    _socket = null;
    _tryConnect();
  }

  //创建websocket连接
  void _tryConnect() {
    // print('========Socket连接=========');
    // print(
    //     'Connecting........  ws:${this.hashCode}  ----  socket:${_socket
    //         .hashCode} ');
    // WebSocket.connect(GlobalConfigs.WEBSOCKET_URL(
    //     http$.getToken(), UserBLoC.instance.currentUser.mobileNumber))
    //     .then((ws) {
    //   _socket = ws;
    //   _socket.listen(
    //         (dynamic message) {
    //       print('========收到推送=========');
    //       print('$message');
    //       notificationsPool$.checkUnread();
    //       try {
    //         WebsocketResponse response =
    //         WebsocketResponse.fromJson(json.decode(message));
    //         if (response != null) {
    //           notificationsPool$.add(response);
    //         }
    //         //系统通知
    //       } catch (e) {
    //         print(e);
    //       }
    //     },
    //     onDone: _onDisconnected,
    //     onError: (dynamic error) => _onDisconnected(),
    //   );
    //   _socket.done.then((dynamic _) => _onDisconnected());
    // });
  }

  ///推送消息
  void send(dynamic message) {
    if (_socket == null) {
      _tryConnect();
    } else {
      print('======发送消息=======');
      print('$message');
      _socket.add(message);
    }
  }

  //心跳检测
  void _heartbeat() {
    _timer = Timer.periodic(_duration, (timer) {
      send('heartbeat test');
    });
  }

  void disconnect() {
    if (_socket != null) {
      _socket.close();
      _socket = null;
    }
  }
}

// var ws$ = WebSocketService();
