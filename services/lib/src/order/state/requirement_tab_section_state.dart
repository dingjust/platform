import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///首页需求Tab状态管理
class RequirementTabSectionState with ChangeNotifier {
  List<RequirementOrderModel> _newRequirements;
  List<RequirementOrderModel> _nearbyRequirements;

  double a_longitude;

  double a_latitude;

  double b_longitude;

  double b_latitude;

  ///最新需求
  List<RequirementOrderModel> getNewRequirements(double longitude,
      double latitude) {
    if (_newRequirements == null ||
        a_longitude != longitude ||
        a_latitude != latitude) {
      queryNewRequirements(longitude, latitude);
    }
    return _newRequirements;
  }

  ///附近需求
  List<RequirementOrderModel> getNearbyRequirements(double longitude,
      double latitude) {
    if (_nearbyRequirements == null ||
        b_longitude != longitude ||
        b_latitude != latitude) {
      _newRequirements = null;
      _nearbyRequirements = null;
      queryNearbyRequirements(longitude, latitude);
    }
    return _nearbyRequirements;
  }

  void queryNewRequirements(double longitude, double latitude) {
    //经纬度为0时不查询
    if (longitude == 0 && latitude == 0) {
      return;
    }
    a_longitude = longitude;
    a_latitude = latitude;
    try {
      http$.post(OrderApis.requirementOrdersMap, data: {
        'longitude': longitude,
        'latitude': latitude,
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
    print('==========$b_longitude===$longitude=======$b_latitude==$latitude');
    //经纬度为0时不查询
    if (longitude == 0 && latitude == 0) {
      return;
    }
    b_longitude = longitude;
    b_latitude = latitude;
    try {
      http$.post(OrderApis.requirementOrdersMap, data: {
        'longitude': longitude,
        'latitude': latitude
      }, queryParameters: {
        'page': 0,
        'size': 5,
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
    print('=============Refresh!');
    _newRequirements = null;
    _newRequirements = null;
    notifyListeners();
  }
}
