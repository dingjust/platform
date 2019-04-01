import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';
import 'package:services/src/order/response/order_response.dart';

class PurchaseOrderBLoC extends BLoCBase {

  // 工厂模式
  factory PurchaseOrderBLoC() => _getInstance();

  static PurchaseOrderBLoC get instance => _getInstance();
  static PurchaseOrderBLoC _instance;

  PurchaseOrderBLoC._internal() {
  }

  static PurchaseOrderBLoC _getInstance() {
    if (_instance == null) {
      _instance = PurchaseOrderBLoC._internal();
    }
    return _instance;
  }

  static final Map<String, PageEntry> _ordersMap = {
    'ALL': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'PENDING_PAYMENT': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'IN_PRODUCTION': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'WAIT_FOR_OUT_OF_STORE': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'OUT_OF_STORE': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'COMPLETED': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
    'CANCELLED': PageEntry(
        currentPage: 0, size: 10, data: List<PurchaseOrderModel>()),
  };

  List<PurchaseOrderModel> orders(String status) => _ordersMap[status].data;

  var _controller = StreamController<List<PurchaseOrderModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get stream => _controller.stream;

  filterByStatuses(String status) async {
    //若没有数据则查询
    if (_ordersMap[status].data.length == 0) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {};
      if (status != 'ALL' && status != 'PENDING_PAYMENT') {
        data = {
          'statuses': [status]
        };
      }
      if (status == 'PENDING_PAYMENT') {
        data = {
          'balancePaid': false,
          'depositPaid': false,
        };
      }
      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(OrderApis.purchaseOrders,
            data: data,
            queryParameters: {
              'page': _ordersMap[status].currentPage,
              'size': _ordersMap[status].size
            });
      } on DioError catch (e) {
        print(e);
      }

    if (response != null && response.statusCode == 200) {
      PurchaseOrdersResponse ordersResponse =
      PurchaseOrdersResponse.fromJson(response.data);
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
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(OrderApis.purchaseOrders,
            data: data,
            queryParameters: {
              'page': ++_ordersMap[status].currentPage,
              'size': _ordersMap[status].size
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse =
        PurchaseOrdersResponse.fromJson(response.data);
        _ordersMap[status].totalPages = ordersResponse.totalPages;
        _ordersMap[status].totalElements = ordersResponse.totalElements;
        _ordersMap[status].data.addAll(ordersResponse.content);
      }
    }

    _loadingController.sink.add(false);
    _controller.sink.add(_ordersMap[status].data);

  }

  // 获取订单明细
  Future<PurchaseOrderModel> getPurchaseOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(OrderApis.purchaseOrderDetail(code));

    if (response.statusCode == 200) {
      PurchaseOrderModel model =
      PurchaseOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  //下拉刷新
  Future refreshData(String status) async {
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
        .    post(OrderApis.purchaseOrders, data: data, queryParameters: {
      'page': _ordersMap[status].currentPage,
      'size': _ordersMap[status].size
    });

    if (response.statusCode == 200) {
      PurchaseOrdersResponse ordersResponse =
      PurchaseOrdersResponse.fromJson(response.data);
      _ordersMap[status].totalPages = ordersResponse.totalPages;
      _ordersMap[status].totalElements = ordersResponse.totalElements;
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
    _loadingController.close();
    _returnToTopController.close();
    _bottomController.close();
    _toTopBtnController.close();
  }
}
