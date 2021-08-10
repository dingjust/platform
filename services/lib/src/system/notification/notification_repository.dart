import 'dart:async';

import 'package:dio/dio.dart';

import 'package:models/models.dart';
import 'package:services/src/net/http_manager.dart';

import '../../../services.dart';

class NotificationRepository {
  static Future<List<NotificationModel>> getNotifications() async {
    Response response;
    try {
      response = await http$.get(Apis.notifications);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        List<dynamic> contents = baseResponse.data;
        return contents.map((e) => NotificationModel.fromJson(e)).toList();
      }
    }
    return null;
  }
}
