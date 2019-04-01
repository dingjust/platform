import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/product/response/apparel_product_response.dart';

class OrderByProductBLoc extends BLoCBase {
  // 工厂模式
  factory OrderByProductBLoc() => _getInstance();

  static OrderByProductBLoc get instance => _getInstance();
  static OrderByProductBLoc _instance;

  OrderByProductBLoc._internal() {
    // 初始化
  }

  static OrderByProductBLoc _getInstance() {
    if (_instance == null) {
      _instance = new OrderByProductBLoc._internal();
    }
    return _instance;
  }

  List<ApparelProductModel> _products = [];

  List<ApparelProductModel> get products => _products;

  var _controller = StreamController<List<ApparelProductModel>>.broadcast();

  Stream<List<ApparelProductModel>> get stream => _controller.stream;

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  getData(String categoryCode) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(ProductApis.factoriesApparel,
            data: {"categories": categoryCode}, queryParameters: {'page': currentPage, 'size': pageSize});
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        ApparelProductResponse productResponse = ApparelProductResponse.fromJson(response.data);
        totalPages = productResponse.totalPages;
        totalElements = productResponse.totalElements;
        _products.clear();
        _products.addAll(productResponse.content);
      }
      _controller.sink.add(_products);
      lock = false;
    }
  }

  loadingMore(String categoryCode) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (currentPage + 1 == totalPages) {
        //通知显示已经到底部
        bottomController.sink.add(true);
      } else {
        Response<Map<String, dynamic>> response;
        try {
          currentPage++;
          response = await http$.post(ProductApis.factoriesApparel,
              data: {"categories": categoryCode}, queryParameters: {'page': currentPage, 'size': pageSize});
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          ApparelProductResponse productResponse = ApparelProductResponse.fromJson(response.data);
          totalPages = productResponse.totalPages;
          totalElements = productResponse.totalElements;
          _products.addAll(productResponse.content);
        }
      }
      loadingController.sink.add(false);
      _controller.sink.add(_products);
      lock = false;
    }
  }

  clear() async {
    //清空
    _products.clear();
    _controller.sink.add(_products);
  }

  void reset() {
    _products = [];
    currentPage = 0;
    totalPages = 0;
    totalElements = 0;
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}
