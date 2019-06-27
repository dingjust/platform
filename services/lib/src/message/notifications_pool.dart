import 'dart:async';

import 'package:services/src/message/notifications_service.dart';
import 'package:services/src/websocket/websocket_response.dart';

///通知池
class NotificationsPool {
  // 工厂模式
  factory NotificationsPool() => _getInstance();

  static NotificationsPool get instance => _getInstance();
  static NotificationsPool _instance;

  ///订单通知
  static final List<WebsocketResponse> _orderNotifications = [];

  ///系统通知
  static final List<WebsocketResponse> _systemNotifications = [];

  ///财务通知
  static final List<WebsocketResponse> _financeNotifications = [];

  ///生产通知(只存Code,用于生产提醒)
  static final Set<String> _productionNotifications = Set();

  ///通知总数流
  var _notificationsNumController = StreamController<int>.broadcast();

  Stream<int> get notificationsNumStream => _notificationsNumController.stream;

  ///订单通知数流
  var _orderNotificationsNumController = StreamController < int

  >

      .

  broadcast();

  Stream<int> get orderNotificationsNumStream =>
      _orderNotificationsNumController.stream;

  ///系统通知数流
  var _systemNotificationsNumController = StreamController < int

  >

      .

  broadcast();

  Stream<int> get systemNotificationsNumStream =>
      _systemNotificationsNumController.stream;

  ///财务通知数流
  var _financeNotificationsNumController = StreamController < int

  >

      .

  broadcast();

  Stream<int> get financeNotificationsNumStream =>
      _financeNotificationsNumController.stream;

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
    switch (noticication.group) {
      case 1:
        _orderNotifications.add(noticication);
        _orderNotificationsNumController.add(orderNotificationsNum);
        break;
      case 2:
        _systemNotifications.add(noticication);
        _systemNotificationsNumController.add(systemNotificationsNum);
        break;
      case 3:
        _financeNotifications.add(noticication);
        _financeNotificationsNumController.add(financeNotificationsNum);
        break;
      default:
    }
    if (noticication.module != MsgModule.DEFAULT) {
      _notificationsNumController.add(notificationsNum);
      //TODO 判断如生产订单类型、加入 _productionNotifications
      ns$.showNotification(noticication.hashCode, '${noticication.title}',
          '${noticication.body}');
    }
  }

  ///点击消息置为已阅
  void read(WebsocketResponse noticication) {
    switch (noticication.group) {
      case 1:
        _orderNotifications.remove(noticication);
        break;
      case 2:
        _systemNotifications.remove(noticication);
        break;
      case 3:
        _financeNotifications.remove(noticication);
        break;
      default:
    }
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
    _orderNotifications.clear();
    _systemNotifications.clear();
    _financeNotifications.clear();
  }

  ///获取全部通知数
  int get notificationsNum =>
      _orderNotifications.length +
          _systemNotifications.length +
          _financeNotifications.length;

  int get orderNotificationsNum => _orderNotifications.length;

  int get systemNotificationsNum => _systemNotifications.length;

  int get financeNotificationsNum => _financeNotifications.length;

  void dispose() {
    _orderNotificationsNumController.close();
    _systemNotificationsNumController.close();
    _financeNotificationsNumController.close();
    _notificationsNumController.close();
  }
}

var notificationsPool$ = NotificationsPool();
