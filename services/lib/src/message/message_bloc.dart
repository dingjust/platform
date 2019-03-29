import 'dart:async';

import 'package:services/services.dart';

class MessageBLoC extends BLoCBase {
  // 工厂模式
  factory MessageBLoC() => _getInstance();

  static MessageBLoC get instance => _getInstance();
  static MessageBLoC _instance;

  MessageBLoC._internal() {
    // 初始化
  }

  static MessageBLoC _getInstance() {
    if (_instance == null) {
      _instance = MessageBLoC._internal();
    }
    return _instance;
  }

  ///错误消息流

  var errorMessageController = StreamController<dynamic>.broadcast();

  Stream<dynamic> get errorMessageStream => errorMessageController.stream;

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
