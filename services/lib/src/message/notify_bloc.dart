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

    try {
      response = await http$.post(Apis.getMsgList(uid),
          data: {
            'groupCode': status
          },
          queryParameters: {
            'page': ++_dataMap[status].currentPage,
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

  loadingMoreByStatuses(String status) async {
    //数据到底
    if (_dataMap[status].currentPage + 1 == _dataMap[status].totalPages) {
      //通知显示已经到底部
      bottomController.sink.add(true);
    } else {
      Map data = {};
      Response<Map<String, dynamic>> response;
      String uid = UserBLoC.instance.currentUser.mobileNumber;
      try {
        response = await http$.post(Apis.getMsgList(uid),
            data: {
              'groupCode': status
            },
            queryParameters: {
              'page': ++_dataMap[status].currentPage,
              'size': _dataMap[status].size,
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response.statusCode == 200) {
        NotifyResponse notifyResponse =
        NotifyResponse.fromJson(response.data);
        _dataMap[status].totalPages = notifyResponse.totalPages;
        _dataMap[status].totalElements = notifyResponse.totalElements;
        _dataMap[status].data.addAll(notifyResponse.content);
      }
    }

    loadingController.sink.add(false);
    _controller.sink.add(MessageData(status: status, data: _dataMap[status].data));
  }

  refreshData(String status) async {
      //重置信息
      _dataMap[status].data.clear();
      await getData(status);
  }

  showNotReadMsg() async {
    _dataMap['1'].data.clear();
    _dataMap['2'].data.clear();
    _dataMap['3'].data.clear();

    Response<Map<String, dynamic>> response;

    String uid = UserBLoC.instance.currentUser.mobileNumber;

    print(uid);

    try {
      response = await http$.post(Apis.getMsgList(uid),
          data: {
            'read': false
          });
    } on DioError catch (e) {
      print(e);
    }
    List<NotifyModel> data = List<NotifyModel>();
    if (response != null && response.statusCode == 200) {
      NotifyResponse notifyResponse =
      NotifyResponse.fromJson(response.data);
      data.addAll(notifyResponse.content);
    }

    if (data != null && data.length > 0) {
//      _dataMap['1'].data.add(_dataMap['dll'].data.firstWhere((_dataMap['all'].data.)))
      for (int i = 0; i < data.length; i++) {
        if (data[i].groupCode.toString() == '1') {
          _dataMap['1'].data.add(data[i]);
        } else if (data[i].groupCode.toString() == '2') {
          _dataMap['2'].data.add(data[i]);
        } else if (data[i].groupCode.toString() == '3') {
          _dataMap['3'].data.add(data[i]);
        }
      }
    }

    _controller.sink.add(MessageData(status: '1', data: _dataMap['1'].data));
    _controller.sink.add(MessageData(status: '2', data: _dataMap['2'].data));
    _controller.sink.add(MessageData(status: '3', data: _dataMap['3'].data));
  }


}

class MessageData {
  String status;

  List<NotifyModel> data;

  MessageData({this.status, this.data});
}
