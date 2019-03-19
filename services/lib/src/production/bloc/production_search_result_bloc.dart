import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/response/order_response.dart';

class ProductionSearchResultBLoC extends BLoCBase {
  // 工厂模式
  factory ProductionSearchResultBLoC() => _getInstance();

  static ProductionSearchResultBLoC get instance => _getInstance();
  static ProductionSearchResultBLoC _instance;

  ProductionSearchResultBLoC._internal() {
    // 初始化
  }

  static ProductionSearchResultBLoC _getInstance() {
    if (_instance == null) {
      _instance = new ProductionSearchResultBLoC._internal();
    }
    return _instance;
  }

  List<PurchaseOrderModel> _purchaseOrders = [];

  List<PurchaseOrderModel> orders() => _purchaseOrders;

  var _controller = StreamController<List<PurchaseOrderModel>>.broadcast();

  Stream<List<PurchaseOrderModel>> get stream => _controller.stream;

  getData(String keyword) async {
    //清空数据
    _purchaseOrders.clear();
    if (_purchaseOrders.isEmpty) {
      //  分页拿数据，response.data;
      //请求参数
      Map data = {
        'code':keyword,
        'skuID': keyword,
        'belongto':keyword,
      };
      Response<Map<String, dynamic>> response;

      try {
        response = await http$.post(OrderApis.purchaseOrders,
            data:data
        );
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        PurchaseOrdersResponse ordersResponse =
        PurchaseOrdersResponse.fromJson(response.data);
        _purchaseOrders.clear();
        _purchaseOrders.addAll(ordersResponse.content);
      }

    }
    _controller.sink.add(_purchaseOrders);
  }

  loadingMore(String keyword) async {
    Map data = {
      'code': keyword,
      'skuID': keyword,
      'belongto': keyword,
    };
    Response<Map<String, dynamic>> response;

    try {
      response = await http$.post(OrderApis.purchaseOrders,
          data: data
      );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      PurchaseOrdersResponse ordersResponse =
      PurchaseOrdersResponse.fromJson(response.data);
      _purchaseOrders.clear();
      _purchaseOrders.addAll(ordersResponse.content);
    }
    _controller.sink.add(_purchaseOrders);
  }

  clear() async {
    //清空
    _purchaseOrders.clear();
    _controller.sink.add(null);
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
