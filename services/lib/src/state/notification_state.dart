import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/src/system/notification/notification_repository.dart';

///公告状态
class NotificationState with ChangeNotifier {
  List<NotificationModel> _notifications;

  List<NotificationModel> get notifications {
    if (_notifications == null) {
      getData();
      return [];
    }
    return _notifications;
  }

  ///获取一个消息
  NotificationModel getNotification() {
    if (_notifications == null || _notifications.isEmpty) {
      getData();
      return NotificationModel(content: '钉单看款做货，原创版衣快速生产就在钉单');
    } else {
      return _notifications.first;
      // return _notifications.removeAt(0);
    }
  }

  void getData() {
    NotificationRepository.getNotifications().then((values) {
      if (values != null) {
        _notifications = values;
        _notifications.sort((o1, o2) => o1.level - o2.level);
        notifyListeners();
      }
    });
  }
}
