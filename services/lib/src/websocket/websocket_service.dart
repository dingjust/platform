import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/bloc/user_bloc.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketService {
  // 工厂模式
  factory WebSocketService() => _getInstance();

  static WebSocketService get instance => _getInstance();
  static WebSocketService _instance;

  IOWebSocketChannel channel;

  WebSocketService._internal() {
    // 初始化
    //创建websocket连接
    channel = new IOWebSocketChannel.connect(
        'ws://192.168.1.137/message?token=${http$.token}&userId=${UserBLoC
            .instance.currentUser.uid}');
  }

  static WebSocketService _getInstance() {
    if (_instance == null) {
      _instance = new WebSocketService._internal();
    }
    return _instance;
  }
}
