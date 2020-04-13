import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/product/product_condition.dart';

class OrderByProductBLoc extends BLoCBase {
  // 工厂模式
  factory OrderByProductBLoc() => _getInstance();

  static OrderByProductBLoc get instance => _getInstance();
  static OrderByProductBLoc _instance;

  ProductsResponse productsResponse;

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

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  getData(ProductCondition productCondition) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(ProductApis.factoriesApparel,
            data: productCondition.toDataJson(),
            queryParameters: {
              'page': currentPage,
              'size': pageSize,
              'sort': productCondition.sortCondition != null
                  ? '${productCondition.sortCondition},${productCondition.sort}'
                  : ''
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        ProductsResponse productResponse =
        ProductsResponse.fromJson(response.data);
        totalPages = productResponse.totalPages;
        totalElements = productResponse.totalElements;
        _products.clear();
        _products.addAll(productResponse.content);
      }
      _controller.sink.add(_products);
      lock = false;
    }
  }

  getCashProducts(String uid) async {
    if (!lock) {
      lock = true;
      try {
        if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
          productsResponse = await ProductRepositoryImpl().list({
            'approvalStatuses': ['approved'],
          }, {});
        } else {
          productsResponse =
              await ProductRepositoryImpl().getProductsOfFactory({
            'approvalStatuses': ['approved'],
          }, {}, uid);
        }
        _products.clear();
        _products.addAll(productsResponse.content);
      } on DioError catch (e) {
        print(e);
      }
      _controller.sink.add(_products);
      lock = false;
    }
  }

  loadingMore(ProductCondition productCondition) async {
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
              data: productCondition.toDataJson(),
              queryParameters: {
                'page': currentPage,
                'size': pageSize,
                'sort': productCondition.sortCondition != null
                    ? '${productCondition.sortCondition},${productCondition
                    .sort}'
                    : ''
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          ProductsResponse productResponse =
          ProductsResponse.fromJson(response.data);
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

  loadingMoreByCastProducts(String uid) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (productsResponse.number + 1 == productsResponse.totalPages) {
        //通知显示已经到底部
        bottomController.sink.add(true);
      } else {
        try {
          if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
            productsResponse = await ProductRepositoryImpl().list({
              'approvalStatuses': ['approved'],
            }, {
              'page': productsResponse.number + 1,
            });
          } else {
            productsResponse =
                await ProductRepositoryImpl().getProductsOfFactory({}, {
              'page': productsResponse.number + 1,
            }, uid);
          }

          _products.addAll(productsResponse.content);
        } on DioError catch (e) {
          print(e);
        }
      }
      loadingController.sink.add(false);
      _controller.sink.add(_products);
      lock = false;
    }
  }

  clear() async {
    //清空
    reset();
    _controller.sink.add(_products);
  }

  clearProducts() {
    _controller.sink.add(null);
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