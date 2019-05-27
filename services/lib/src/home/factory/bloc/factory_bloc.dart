import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';

class FactoryBLoC extends BLoCBase {
  // 工厂模式
  factory FactoryBLoC() => _getInstance();

  static FactoryBLoC get instance => _getInstance();
  static FactoryBLoC _instance;

  FactoryBLoC._internal() {
    // 初始化
  }

  static FactoryBLoC _getInstance() {
    if (_instance == null) {
      _instance = new FactoryBLoC._internal();
    }
    return _instance;
  }

  List<FactoryModel> _factories = [];

  List<FactoryModel> get factories => _factories;

  var _controller = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<FactoryModel>> get stream => _controller.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  //查询所有工厂列表
  filterByCondition(
    FactoryCondition factoryCondition, {
    String condition = '',
    String sort = '',
    String requirementCode,
    double longitude,
    double latitude,
    double distance,
  }) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Response<Map<String, dynamic>> response;
      if ((factoryCondition.longitude != null && factoryCondition.longitude > 0) &&
          (factoryCondition.latitude != null && factoryCondition.latitude > 0) &&
          (factoryCondition.distance != null && factoryCondition.distance > 0)) {
        try {
          print(11);
          response = await http$.post(Apis.factoriesForMap,
              data: factoryCondition.toDataJson(),
              // data:{},
              queryParameters: {
//                'longitude':113.32106,
//                'latitude':23.10625,
                'page': currentPage,
                'size': pageSize,
                'sort': '${condition},${sort}'
              });
        } on DioError catch (e) {
          print(e);
        }
      }else{
        if (requirementCode != null && requirementCode != '') {
          try {
            print(22);
            response = await http$.post(
                Apis.requestQuoteFactories(requirementCode),
                data: factoryCondition.toDataJson(),
                queryParameters: {
                  'page': currentPage,
                  'size': pageSize,
                  'sort': '${condition},${sort}'
                });
          } on DioError catch (e) {
            print(e);
          }
        } else {
          try {
            response = await http$.post(Apis.factories,
                data: factoryCondition.toDataJson(),
                // data:{},
                queryParameters: {
                  'page': currentPage,
                  'size': pageSize,
                  'sort': '${condition},${sort}'
                });
          } on DioError catch (e) {
            print(e);
          }
        }
      }


      if (response != null && response.statusCode == 200) {
        FactoriesResponse factoriesResponse =
            FactoriesResponse.fromJson(response.data);
        totalPages = factoriesResponse.totalPages;
        totalElements = factoriesResponse.totalElements;
        _factories.clear();
        _factories.addAll(factoriesResponse.content);
      }
      _controller.sink.add(_factories);
      lock = false;
    }
  }

  //邀请报价的工厂列表
  filterRequestQuoteByCondition(
    FactoryCondition factoryCondition, {
    String condition,
    String sort,
    String requirementCode,
  }) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(Apis.requestQuoteFactories(requirementCode),
            data: factoryCondition.toDataJson(),
            queryParameters: {
              'page': currentPage,
              'size': pageSize,
              'sort': '${condition},${sort}'
            });
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        FactoriesResponse factoriesResponse =
            FactoriesResponse.fromJson(response.data);
        totalPages = factoriesResponse.totalPages;
        totalElements = factoriesResponse.totalElements;
        _factories.clear();
        _factories.addAll(factoriesResponse.content);
      }
      _controller.sink.add(_factories);
      lock = false;
    }
  }

  loadingMoreByCondition(
    FactoryCondition factoryCondition, {
    String condition,
    String sort,
    String requirementCode,
    double longitude,
    double latitude,
    double distance,
  }) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (currentPage + 1 == totalPages) {
        //通知显示已经到底部
        _bottomController.sink.add(true);
      } else {
        Response<Map<String, dynamic>> response;
        if ((factoryCondition.longitude != null && factoryCondition.longitude > 0) &&
            (factoryCondition.latitude != null && factoryCondition.latitude > 0) &&
            (factoryCondition.distance != null && factoryCondition.distance > 0)) {
          try {
            print(11);
            currentPage++;
            response = await http$.post(Apis.factoriesForMap,
                data: factoryCondition.toDataJson(),
                queryParameters: {
                  'page': currentPage,
                  'size': pageSize,
                  'sort': '${condition},${sort}'
                });
          } on DioError catch (e) {
            print(e);
          }
        }else {
          if (requirementCode != null && requirementCode != '') {
            try {
              currentPage++;
              response = await http$.post(
                  Apis.requestQuoteFactories(requirementCode),
                  data: factoryCondition.toDataJson(),
                  queryParameters: {
                    'page': currentPage,
                    'size': pageSize,
                    'sort': '${condition},${sort}'
                  });
            } on DioError catch (e) {
              print(e);
            }
          } else {
            try {
              currentPage++;
              response = await http$.post(Apis.factories,
                  data: factoryCondition.toDataJson(),
                  queryParameters: {
                    'page': currentPage,
                    'size': pageSize,
                    'sort': '${condition},${sort}'
                  });
            } on DioError catch (e) {
              print(e);
            }
          }
        }
        if (response != null && response.statusCode == 200) {
          FactoriesResponse factoriesResponse =
              FactoriesResponse.fromJson(response.data);
          totalPages = factoriesResponse.totalPages;
          totalElements = factoriesResponse.totalElements;
          _factories.addAll(factoriesResponse.content);
        }
      }
      _loadingController.sink.add(false);
      _controller.sink.add(_factories);
      lock = false;
    }
  }

  //邀请报价的工厂列表
  loadingMoreRequestQuoteByCondition(
    FactoryCondition factoryCondition, {
    String condition,
    String sort,
    String requirementCode,
  }) async {
    if (!lock) {
      lock = true;

      //数据到底
      if (currentPage + 1 == totalPages) {
        //通知显示已经到底部
        _bottomController.sink.add(true);
      } else {
        Response<Map<String, dynamic>> response;
        try {
          currentPage++;
          response = await http$.post(
              Apis.requestQuoteFactories(requirementCode),
              data: factoryCondition.toDataJson(),
              queryParameters: {
                'page': currentPage,
                'size': pageSize,
                'sort': '${condition},${sort}'
              });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          FactoriesResponse factoriesResponse =
              FactoriesResponse.fromJson(response.data);
          totalPages = factoriesResponse.totalPages;
          totalElements = factoriesResponse.totalElements;
          _factories.addAll(factoriesResponse.content);
        }
      }
      _loadingController.sink.add(false);
      _controller.sink.add(_factories);
      lock = false;
    }
  }

  clear() async {
    //清空
    _factories.clear();
    _controller.sink.add(null);
  }

  void reset() {
    _factories = [];
    currentPage = 0;
    totalPages = 0;
    totalElements = 0;
  }

  //下拉刷新
  Future refreshData({String condition, bool isDESC}) async {}

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
