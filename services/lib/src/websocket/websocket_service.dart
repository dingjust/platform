import 'dart:io';

import 'package:services/src/message/notifications_service.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/bloc/user_bloc.dart';

class WebSocketService {
  // 工厂模式
  factory WebSocketService() => _getInstance();

  static WebSocketService get instance => _getInstance();
  static WebSocketService _instance;

  WebSocket _socket;

  WebSocketService._internal() {
    // 初始化
    _tryConnect();
  }

  static WebSocketService _getInstance() {
    if (_instance == null) {
      _instance = new WebSocketService._internal();
    }
    return _instance;
  }

  void _onDisconnected() {
    print('Disconnected    ${this.hashCode}  ----  ${_socket.hashCode}');
    if (_socket != null) {
      _socket.close();
    }
    _socket = null;
    _tryConnect();
  }

  //创建websocket连接
  void _tryConnect() {
    print('Connecting........    ${this.hashCode}  ----  ${_socket.hashCode} ');
    WebSocket.connect(
        'ws://192.168.1.137/message?token=${http$.getToken()}&userId=${UserBLoC
            .instance.currentUser.mobileNumber}')
        .then((ws) {
      _socket = ws;
      _socket.listen(
            (dynamic message) {
          print(message);
          ns$.showNotification(
              message.hashCode, 'message.title', 'message.body');
        },
        onDone: _onDisconnected,
        onError: (dynamic error) => _onDisconnected(),
      );
      _socket.done.then((dynamic _) => _onDisconnected());
    });
  }

  void send(dynamic message) {
    if (_socket == null) {
      _tryConnect();
    } else {
      _socket.add('data');
    }
  }
}

var ws$ = WebSocketService();
