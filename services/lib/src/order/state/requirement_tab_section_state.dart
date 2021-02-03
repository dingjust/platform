import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///首页需求Tab状态管理
class RequirementTabSectionState with ChangeNotifier {
  List<RequirementOrderModel> _newRequirements;
  List<RequirementOrderModel> _nearbyRequirements;

  double _longitude;

  double _latitude;

  ///最新需求
  List<RequirementOrderModel> getNewRequirements() {
    if (_newRequirements == null) {
      queryNewRequirements();
    }
    return _newRequirements;
  }

  ///附近需求
  List<RequirementOrderModel> getNearbyRequirements(
      double longitude, double latitude) {
    if (_nearbyRequirements == null ||
        _longitude != longitude ||
        _latitude != latitude) {
      _newRequirements = null;
      _nearbyRequirements = null;
      queryNearbyRequirements(longitude, latitude);
    }
    return _nearbyRequirements;
  }

  ///最新需求
  void queryNewRequirements() {
    try {
      http$.post(OrderApis.requirementOrdersAnonymous, data: {
        'statuses': "PENDING_QUOTE"
      }, queryParameters: {
        'page': 0,
        'size': 5,
        "sort": "creationtime,DESC"
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          RequirementOrdersResponse requirementOrdersResponse =
              RequirementOrdersResponse.fromJson(response.data);
          _newRequirements = requirementOrdersResponse.content;

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  void queryNearbyRequirements(double longitude, double latitude) {
    //经纬度为0时不查询
    if (longitude == 0 && latitude == 0) {
      throw Exception('经纬度错误');
    }
    _longitude = longitude;
    _latitude = latitude;
    try {
      http$.post(OrderApis.requirementOrdersMap, data: {
        'longitude': longitude ?? 113.264434,
        'latitude': latitude ?? 23.129162,
        'statuses': "PENDING_QUOTE"
      }, queryParameters: {
        'page': 0,
        'size': 5,
        "sort": "creationtime,DESC"
      }).then((response) {
        if (response != null && response.statusCode == 200) {
          RequirementOrdersResponse requirementOrdersResponse =
          RequirementOrdersResponse.fromJson(response.data);
          _nearbyRequirements = requirementOrdersResponse.content;

          ///通知刷新
          notifyListeners();
        }
      });
    } on DioError catch (e) {
      print(e);
    }
  }

  void refresh() {
    _newRequirements = null;
    _newRequirements = null;
    notifyListeners();
  }
}
