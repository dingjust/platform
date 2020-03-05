import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/apis.dart';
import 'package:services/src/message/response/message_response.dart';
import 'package:services/src/net/http_manager.dart';

class MessageRepository {
  /// 获取未读消息数
  Future<CountUnreadResponse> countUnread(String uid) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.post(Apis.countUnreadMsg(uid),
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      CountUnreadResponse model = CountUnreadResponse.fromJson(response.data);
      return model;
    } else
      return null;
  }

  ///消息标记未读
  Future<bool> readMessage(String uid, List<String> codes) async {
    var response;
    // String response;
    try {
      response = await http$.post(Apis.readMsg(uid),
          data: codes,
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseMsg model = BaseMsg.fromJson(response.data);
      return model.code == 1;
    } else
      return false;
  }

  ///全部消息标记未读
  Future<bool> readAllMessage(String uid) async {
    var response;
    try {
      response = await http$.post(Apis.readAllMsg(uid),
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data as bool;
    } else
      return false;
  }

  ///删除消息
  Future<bool> deleteMessage(String uid, String code) async {
    var response;
    // String response;
    try {
      response = await http$.post(Apis.deleteMsg(uid),
          data:[code],
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      BaseMsg model = BaseMsg.fromJson(response.data);
      return model.code == 1;
    } else
      return false;
  }
}
