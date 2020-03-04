import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:services/src/message/jpush_service.dart';
import 'package:services/src/message/notifications_service.dart';
import 'package:services/src/message/repository/message_respository.dart';
import 'package:services/src/message/response/jpush_response.dart';
import 'package:services/src/production/bloc/production_bloc.dart';
import 'package:services/src/user/bloc/user_bloc.dart';
import 'package:services/src/websocket/websocket_response.dart';

import 'response/message_response.dart';

///通知池
class NotificationsPool {
  // 工厂模式
  factory NotificationsPool() => _getInstance();

  static NotificationsPool get instance => _getInstance();
  static NotificationsPool _instance;

  Timer _timer;

  ///轮询时间间隔
  Duration _duration = Duration(seconds: GlobalConfigs.HEARTBEAT_DURATION);

  ///订单通知数
  int _orderNotificationsNum = 0;

  ///系统通知数
  int _systemNotificationsNum = 0;

  ///财务通知数
  int _financeNotificationsNum = 0;

  ///生产通知(只存Code,用于生产提醒)
  static final Set<String> _productionNotifications = Set();

  ///通知总数流
  var _notificationsNumController = StreamController<int>.broadcast();

  Stream<int> get notificationsNumStream => _notificationsNumController.stream;

  ///订单通知数流
  var _orderNotificationsNumController = StreamController<int>.broadcast();

  Stream<int> get orderNotificationsNumStream =>
      _orderNotificationsNumController.stream;

  ///系统通知数流
  var _systemNotificationsNumController = StreamController<int>.broadcast();

  Stream<int> get systemNotificationsNumStream =>
      _systemNotificationsNumController.stream;

  ///财务通知数流
  var _financeNotificationsNumController = StreamController<int>.broadcast();

  Stream<int> get financeNotificationsNumStream =>
      _financeNotificationsNumController.stream;

  NotificationsPool._internal() {
    // 初始化
    checkUnread();
    //轮询
    _pollingCheck();
  }

  static NotificationsPool _getInstance() {
    if (_instance == null) {
      _instance = new NotificationsPool._internal();
    }
    return _instance;
  }

  ///新增通知
  void add(WebsocketResponse noticication) async {
    // if (noticication.module != MsgModule.DEFAULT) {
    //   //TODO 判断如生产订单类型、加入 _productionNotifications
    //   ns$.showNotification(noticication.hashCode, '${noticication.title}',
    //       '${noticication.body}',
    //       payload: json.encode(WebsocketResponse.toJson(noticication)));
    // }
  }

  ///点击消息置为已阅
  Future<bool> read(List<String> codes) async {
    bool result = await MessageRepository()
        .readMessage(UserBLoC.instance.currentUser.mobileNumber, codes);
    if (result) {
      checkUnread();
    }
    return result;
  }

  Future<bool> readAll() async {
    bool result = await MessageRepository()
        .readAllMessage(UserBLoC.instance.currentUser.mobileNumber);
    if (result) {
      checkUnread();
    }
    return result;
  }

  ///点击生产消息置为已阅
  void readProductionNotifications(String code) {
    _productionNotifications.remove(code);
  }

  ///生产是否有新消息
  bool hasNotification(String code) {
    _productionNotifications.contains(code);
  }

  ///未读消息数
  void checkUnread() async {
    if (UserBLoC.instance.currentUser.status != UserStatus.OFFLINE) {
      CountUnreadResponse countUnreadResponse = await MessageRepository()
          .countUnread(UserBLoC.instance.currentUser.mobileNumber);
      if (countUnreadResponse != null) {
        _orderNotificationsNum = countUnreadResponse.order;
        _systemNotificationsNum = countUnreadResponse.system;
        _financeNotificationsNum = countUnreadResponse.finance;
        _orderNotificationsNumController.add(orderNotificationsNum);
        _systemNotificationsNumController.add(systemNotificationsNum);
        _financeNotificationsNumController.add(financeNotificationsNum);
        _notificationsNumController.add(notificationsNum);
      }
    }
  }

  void _pollingCheck() {
    _timer = Timer.periodic(_duration, (timer) {
      checkUnread();
    });
  }

  ///分析推送消息生产进度是否刷新
  void analysProductionMessage(Map<String, dynamic> message) {
    TargetPlatform platform = defaultTargetPlatform;
    if (platform == TargetPlatform.iOS) {
      JPushIOSResponse response = JPushIOSResponse.fromJson(message);
      if (PAGE_ROUTE_MAP[response.module] == 3) {
        ProductionBLoC.instance.refreshData('');
      }
    } else {
      JPushAndroidResponse response = JPushAndroidResponse.fromJson(message);
      if (PAGE_ROUTE_MAP[response.extras.androidExtras.module] == 3) {
        ProductionBLoC.instance.refreshData('');
      }
    }
  }

  ///获取全部通知数
  int get notificationsNum =>
      _orderNotificationsNum +
      _systemNotificationsNum +
      _financeNotificationsNum;

  int get orderNotificationsNum => _orderNotificationsNum;

  int get systemNotificationsNum => _systemNotificationsNum;

  int get financeNotificationsNum => _financeNotificationsNum;

  void dispose() {
    _orderNotificationsNumController.close();
    _systemNotificationsNumController.close();
    _financeNotificationsNumController.close();
    _notificationsNumController.close();
  }
}

var notificationsPool$ = NotificationsPool();
