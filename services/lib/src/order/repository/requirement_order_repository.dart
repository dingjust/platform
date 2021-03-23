import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementOrderRepository {
  /// 发布需求
  Future<String> publishNewRequirement(
      RequirementOrderModel form, String factoryUid, bool privacy,
      {String factories}) async {
    Map<String, dynamic> map = {};
    if (factoryUid != null) {
      map['factory'] = factoryUid;
      map['privacy'] = privacy;
    }

    if (factories != null) {
      map['factories'] = factories;
      map['privacy'] = privacy;
    }

    Response response;
    try {
      response = await http$.post(
          OrderApis.requirementOrderNew + '?factories=' + factories,
          data: RequirementOrderModel.toJson(form),
//          queryParameters: map,
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  /// 获取订单明细
  Future<RequirementOrderModel> getRequirementOrderDetail(String code) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.requirementOrderDetail(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      RequirementOrderModel model =
          RequirementOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  /// 根据订单编号获取报价单列表
  Future<List<QuoteModel>> getRequirementOrderQuotes(
      {String code, int size, int page}) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.requirementOrderQuotes(code),
          data: {'page': page, 'size': size});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      QuoteOrdersResponse ordersResponse =
          QuoteOrdersResponse.fromJson(response.data);
      return ordersResponse.content;
    } else
      return null;
  }

  /// 更新需求信息
  Future<String> updateRequirement(RequirementOrderModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.requirementUpdate(form.code),
          data: RequirementOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //邀请报价（推荐需求）
  Future<bool> doRecommendation(String code, String factoryId) async {
    Response response;
    try {
      response = await http$.put(OrderApis.doRecommendation(code, factoryId),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //邀请报价（推荐需求）
  Future<bool> doRecommendations(
      List<String> codes, List<String> factoryUids) async {
    print(codes);
    print(factoryUids.join(','));
    Response response;
    try {
      response = await http$.put(OrderApis.doRecommendations(),
          options: Options(responseType: ResponseType.plain),
          queryParameters: {
            'codes': codes.join(','),
            'factoryUids': factoryUids.join(','),
          });
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 订单关闭
  Future<String> requirementOrderCancle(String code) async {
    Response response;
    try {
      response = await http$.delete(OrderApis.requirementOrderCancle(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return 'success';
    } else
      return null;
  }

  ///获取需求池信息
  static Future<RequirementOrdersResponse> getRequirementsAnonymous(
      {Map<String, dynamic> params = const {},
        Map<String, dynamic> data = const {}}) async {
    Response response;
    try {
      response = await http$.post(OrderApis.requirementOrdersAnonymous,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      RequirementOrdersResponse result =
      RequirementOrdersResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }
}
