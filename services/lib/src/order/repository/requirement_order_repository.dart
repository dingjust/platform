import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementOrderRepository {
  /// 发布需求
  Future<String> publishNewRequirement(RequirementOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.requirementOrderNew,
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
}
