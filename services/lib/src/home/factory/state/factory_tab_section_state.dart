import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';

///首页工厂Tab状态管理
class FactoryTabSectionState with ChangeNotifier {
  List<FactoryModel> _newFactories;
  List<FactoryModel> _hotFactories;

  ///最新工厂
  List<FactoryModel> get newFactories {
    if (_newFactories == null) {
      getNewFactories();
    }
    return _newFactories;
  }

  List<FactoryModel> get hotFactories {
    if (_hotFactories == null) {
      getHotFactories();
    }
    return _hotFactories;
  }

  void getNewFactories() {
    try {
      http$.post(Apis.factories, data: {
        'profileCompleted': true
      }, queryParameters: {
        'page': 0,
        'size': 5,
        'sort': 'creationtime,desc'
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          FactoriesResponse factoriesResponse =
              FactoriesResponse.fromJson(response.data);
          _newFactories = factoriesResponse.content;

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  void getHotFactories() {
    try {
      http$.post(Apis.factories, data: {}, queryParameters: {
        'page': 0,
        'size': 5,
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          FactoriesResponse factoriesResponse =
              FactoriesResponse.fromJson(response.data);
          _hotFactories = factoriesResponse.content;

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }
}
