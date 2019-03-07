import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/order_response.dart';

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

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].data.length == 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {};
      if (status != 'ALL') {
        data = {
          'statuses': [status]
        };
      }
      Response<Map<String, dynamic>> response = await http$
          .post(OrderApis.requirementOrders, data: data, queryParameters: {
        'page': _ordersMap[status].currentPage,
        'size': _ordersMap[status].size
      });

      if (response.statusCode == 200) {
        RequirementOrdersResponse ordersResponse =
            RequirementOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.clear();
        _ordersMap[status].data.addAll(ordersResponse.content);
      }
    }
    _controller.sink.add(_ordersMap[status].data);
  }

  loadingMoreByStatuses(String status) async {
    //数据到底
    if (_ordersMap[status].currentPage + 1 == _ordersMap[status].totalPages) {
      //通知显示已经到底部
      _bottomController.sink.add(true);
    } else {
      Map data = {};
      if (status != 'ALL') {
        data = {
          'statuses': [status]
        };
      }
      Response<Map<String, dynamic>> response = await http$
          .post(OrderApis.requirementOrders, data: data, queryParameters: {
        'page': ++_ordersMap[status].currentPage,
        'size': _ordersMap[status].size
      });

      if (response.statusCode == 200) {
        RequirementOrdersResponse ordersResponse =
            RequirementOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.addAll(ordersResponse.content);
      }
    }
    _loadingController.sink.add(false);
    _controller.sink.add(_ordersMap[status].data);
  }

  // 获取订单明细
  Future<RequirementOrderModel> getRequirementOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
        await http$.get(OrderApis.requirementOrderDetail(code));

    if (response.statusCode == 200) {
      RequirementOrderModel model =
          RequirementOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  //下拉刷新
  refreshData(String status) async {
    //重置信息
    _ordersMap[status].data.clear();
    _ordersMap[status].currentPage = 0;
    //  分页拿数据，response.data;
    //请求参数
    Map data = {};
    if (status != 'ALL') {
      data = {
        'statuses': [status]
      };
    }
    Response<Map<String, dynamic>> response = await http$
        .post(OrderApis.requirementOrders, data: data, queryParameters: {
      'page': _ordersMap[status].currentPage,
      'size': _ordersMap[status].size
    });

    if (response.statusCode == 200) {
      RequirementOrdersResponse ordersResponse =
          RequirementOrdersResponse.fromJson(response.data);
      _ordersMap[status].totalPages = ordersResponse.totalPages;
      _ordersMap[status].totalElements = ordersResponse.totalElements;
      _ordersMap[status].data.clear();
      _ordersMap[status].data.addAll(ordersResponse.content);
    }
    _controller.sink.add(_ordersMap[status].data);
  }

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }

  dispose() {
    _controller.close();
  }
}
