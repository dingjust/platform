import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';
import 'package:services/src/order/PageEntry.dart';

class NotifyBloC extends BLoCBase {
  // 工厂模式
  factory NotifyBloC() => _getInstance();

  static NotifyBloC get instance => _getInstance();
  static NotifyBloC _instance;

  bool lock = false;

  static final Map<String, PageEntry> _dataMap = {
    '1': PageEntry(currentPage: 0, size: 10, data: List<NotifyModel>()),
    '2': PageEntry(currentPage: 0, size: 10, data: List<NotifyModel>()),
    '3': PageEntry(currentPage: 0, size: 10, data: List<NotifyModel>()),
  };

  var _controller = StreamController <MessageData>.broadcast();

  NotifyBloC._internal() {}

  static NotifyBloC _getInstance() {
    if (_instance == null) {
      _instance = NotifyBloC._internal();
    }
    return _instance;
  }

  Stream<MessageData> get stream => _controller.stream;

  getData(String status) async {

    Response<Map<String, dynamic>> response;

    String uid = UserBLoC.instance.currentUser.mobileNumber;

    print(uid);

    try {
      response = await http$.post(Apis.getMsgList(uid),
          data: {
            'groupCode': status
          },
          queryParameters: {
            'page': _dataMap[status].currentPage,
            'size': _dataMap[status].size
          });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      NotifyResponse notifyResponse =
      NotifyResponse.fromJson(response.data);
      _dataMap[status].totalPages = notifyResponse.totalPages;
      _dataMap[status].totalElements = notifyResponse.totalElements;
      _dataMap[status].data.clear();
      _dataMap[status].data.addAll(notifyResponse.content);
    }

  _controller.sink.add(MessageData(status: status, data: _dataMap[status].data));

  }

  refreshData(String status) async {
      //重置信息
      _dataMap[status].data.clear();
      await getData(status);
  }


}

class MessageData {
  String status;

  List<NotifyModel> data;

  MessageData({this.status, this.data});
}
