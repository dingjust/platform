import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/capacity/response/capacity_response.dart';
import 'package:services/src/net/http_manager.dart';

class CapacityRepository {
  ///创建产能
  Future<bool> save(FactoryCapacityModel model) async {
    Response response;
    try {
      response = await http$.post(CapacityApis.save,
          data: FactoryCapacityModel.toJson(model));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseMsg msg = BaseMsg.fromJson(response.data);
      return msg.resultCode == 0;
    } else {
      return false;
    }
  }

  ///当前公司产能列表
  Future<FactoryCapacityResponse> list(dynamic data,
      Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(CapacityApis.list,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      FactoryCapacityResponse result =
      FactoryCapacityResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///品牌端查询
  Future<FactoryCapacityResponse> search(dynamic data,
      Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(CapacityApis.search,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      FactoryCapacityResponse result =
      FactoryCapacityResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///切换状态
  Future<bool> switchStatus(String code, bool enabled) async {
    Response response;
    try {
      response = await http$
          .get(CapacityApis.switchStatus(code), data: {'enabled': enabled});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseMsg msg = BaseMsg.fromJson(response.data);
      return msg.resultCode == 0;
    } else {
      return false;
    }
  }

  ///刷新
  Future<bool> refresh(String code) async {
    Response response;
    try {
      response = await http$.get(CapacityApis.refresh(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseMsg msg = BaseMsg.fromJson(response.data);
      return msg.resultCode == 0;
    } else {
      return false;
    }
  }
}
