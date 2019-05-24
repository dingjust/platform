import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class RequirementOrderBLoC extends BLoCBase {
  // 工厂模式
  factory RequirementOrderBLoC() => _getInstance();

  static RequirementOrderBLoC get instance => _getInstance();
  static RequirementOrderBLoC _instance;

  RequirementOrderBLoC._internal() {
    // 初始化
  }

  static RequirementOrderBLoC _getInstance() {
    if (_instance == null) {
      _instance = new RequirementOrderBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, PageEntry> _ordersMap = {
    'ALL': PageEntry(
        currentPage: 0, size: 10, data: List<RequirementOrderModel>()),
    'PENDING_QUOTE': PageEntry(
        currentPage: 0, size: 10, data: List<RequirementOrderModel>()),
    'COMPLETED': PageEntry(
        currentPage: 0, size: 10, data: List<RequirementOrderModel>()),
    'CANCELLED': PageEntry(
        currentPage: 0, size: 10, data: List<RequirementOrderModel>()),
  };

  List<RequirementOrderModel> orders(String status) => _ordersMap[status].data;

  var _controller = StreamController<List<RequirementOrderModel>>.broadcast();

  Stream<List<RequirementOrderModel>> get stream => _controller.stream;

  //锁
  bool lock = false;

  filterByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //若没有数据则查询
      if (_ordersMap[status].data.isEmpty) {
        //  分页拿数据，response.data;
        //请求参数
        Map data = {};
        if (status != 'ALL') {
          data = {
            'statuses': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.requirementOrders,
              data: data,
              queryParameters: {
                'page': _ordersMap[status].currentPage,
                'size': _ordersMap[status].size
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          RequirementOrdersResponse ordersResponse =
          RequirementOrdersResponse.fromJson(response.data);
          _ordersMap[status].totalPages = ordersResponse.totalPages;
          _ordersMap[status].totalElements = ordersResponse.totalElements;
          _ordersMap[status].data.clear();
          _ordersMap[status].data.addAll(ordersResponse.content);
        }
      }
      _controller.sink.add(_ordersMap[status].data);
      lock = false;
    }
  }

  filterByKeyword(String keyword) async {
    //请求参数
    Map data = {
      'keyword': keyword,
    };
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.post(OrderApis.requirementOrders,
          data: data,
          queryParameters: {
            'page': _ordersMap['ALL'].currentPage,
            'size': _ordersMap['ALL'].size
          });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      RequirementOrdersResponse ordersResponse =
      RequirementOrdersResponse.fromJson(response.data);
      _ordersMap['ALL'].totalPages = ordersResponse.totalPages;
      _ordersMap['ALL'].totalElements = ordersResponse.totalElements;
      _ordersMap['ALL'].data.clear();
      _ordersMap['ALL'].data.addAll(ordersResponse.content);
    }
    _controller.sink.add(_ordersMap['ALL'].data);
  }

  loadingMoreByStatuses(String status) async {
    if (!lock) {
      lock = true;
      //数据到底
      if (_ordersMap[status].currentPage + 1 == _ordersMap[status].totalPages) {
        //通知显示已经到底部
        bottomController.sink.add(true);
      } else {
        Map data = {};
        if (status != 'ALL') {
          data = {
            'statuses': [status]
          };
        }
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(OrderApis.requirementOrders,
              data: data,
              queryParameters: {
                'page': ++_ordersMap[status].currentPage,
                'size': _ordersMap[status].size
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          RequirementOrdersResponse ordersResponse =
          RequirementOrdersResponse.fromJson(response.data);
          _ordersMap[status].totalPages = ordersResponse.totalPages;
          _ordersMap[status].totalElements = ordersResponse.totalElements;
          _ordersMap[status].data.addAll(ordersResponse.content);
        }
      }
      loadingController.sink.add(false);
      _controller.sink.add(_ordersMap[status].data);
      lock = false;
    }
  }

  loadingMoreByKeyword(String keyword) async {
    //数据到底
    Map data = {
      'code': keyword,
    };
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.post(OrderApis.requirementOrders,
          data: data,
          queryParameters: {
            'page': ++_ordersMap['ALL'].currentPage,
            'size': _ordersMap['ALL'].size
          });
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      RequirementOrdersResponse ordersResponse =
      RequirementOrdersResponse.fromJson(response.data);
      _ordersMap['ALL'].totalPages = ordersResponse.totalPages;
      _ordersMap['ALL'].totalElements = ordersResponse.totalElements;
      _ordersMap['ALL'].data.addAll(ordersResponse.content);
    }
    loadingController.sink.add(false);
    _controller.sink.add(_ordersMap['ALL'].data);
  }

  //下拉刷新
  refreshData(String status) async {
    if (!lock) {
      //重置信息
      _ordersMap[status].data.clear();
      _ordersMap[status].currentPage = 0;
      await filterByStatuses(status);
    }
  }

  ///重置数据
  void reset() {
    _ordersMap.forEach((statu, entry) {
      entry.data.clear();
      entry.currentPage = 0;
    });
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}
