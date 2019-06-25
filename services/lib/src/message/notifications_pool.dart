import 'dart:async';

import 'package:services/src/message/notifications_service.dart';
import 'package:services/src/websocket/websocket_response.dart';

class NotificationsPool {
  // 工厂模式
  factory NotificationsPool() => _getInstance();

  static NotificationsPool get instance => _getInstance();
  static NotificationsPool _instance;

  static final List<WebsocketResponse> _notifications = [];

  ///生产通知(只存Code)
  static final Set<String> _productionNotifications = Set();

  ///全部通知数流
  var _notificationsNumController = StreamController<int>.broadcast();

  Stream<int> get notificationsNumStream => _notificationsNumController.stream;

  NotificationsPool._internal() {
    // 初始化
  }

  static NotificationsPool _getInstance() {
    if (_instance == null) {
      _instance = new NotificationsPool._internal();
    }
    return _instance;
  }

  ///新增通知
  void add(WebsocketResponse noticication) {
    _notifications.add(noticication);
    //TODO 判断如生产订单类型、加入 _productionNotifications
    _notificationsNumController.add(notificationsNum);
    ns$.showNotification(
        noticication.hashCode, '${noticication.title}', '${noticication.body}');
  }

  ///点击消息置为已阅
  void read(WebsocketResponse noticication) {
    _notifications.remove(noticication);
  }

  ///点击生产消息置为已阅
  void readProductionNotifications(String code) {
    _productionNotifications.remove(code);
  }

  ///生产是否有新消息
  bool hasNotification(String code) {
    _productionNotifications.contains(code);
  }

  void readAll() {
    _notifications.clear();
  }

  ///获取通知数
  int get notificationsNum => _notifications.length;

  void dispose() {
    _notificationsNumController.close();
  }
}

var notificationsPool$ = NotificationsPool();
