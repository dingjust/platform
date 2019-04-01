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

  Stream<FilterConditionEntry> get conditionStream => conditionController.stream;

  int pageSize = 10;
  int currentPage = 0;
  int totalPages = 0;
  int totalElements = 0;

  //锁
  bool lock = false;

  filterByCondition(FactoryCondition factoryCondition, {String condition, bool isDESC}) async {
    if (!lock) {
      lock = true;
      //重置参数
      reset();
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.post(Apis.factories,
            data: factoryCondition.toDataJson(), queryParameters: {'page': currentPage, 'size': pageSize});
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        FactoriesResponse factoriesResponse = FactoriesResponse.fromJson(response.data);
        totalPages = factoriesResponse.totalPages;
        totalElements = factoriesResponse.totalElements;
        _factories.clear();
        _factories.addAll(factoriesResponse.content);
      }
      _controller.sink.add(_factories);
      lock = false;
    }
  }

  loadingMoreByCondition(FactoryCondition factoryCondition, {String condition, bool isDESC}) async {
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
          response = await http$.post(Apis.factories,
              data: factoryCondition.toDataJson(), queryParameters: {'page': currentPage, 'size': pageSize});
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          FactoriesResponse factoriesResponse = FactoriesResponse.fromJson(response.data);
          totalPages = factoriesResponse.totalPages;
          totalElements = factoriesResponse.totalElements;
          _factories.addAll(factoriesResponse.content);
        }
      }
      loadingController.sink.add(false);
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

  dispose() {
    _controller.close();
    conditionController.close();

    super.dispose();
  }
}
