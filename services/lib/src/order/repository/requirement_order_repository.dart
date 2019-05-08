import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RequirementOrderRepository {
  /// 发布需求
  Future<String> publishNewRequirement(RequirementOrderModel form, String factoryUid , bool privacy) async {
    print(form.details.category);
    print(form.details.expectedMachiningQuantity);
    print(form.details.expectedDeliveryDate);
    print(form.details.contactPerson);
    print(form.details.contactPhone);
    RequirementOrderModel model = RequirementOrderModel(details: RequirementInfoModel());
    model.details.category = form.details.category;
    model.details.expectedMachiningQuantity = form.details.expectedMachiningQuantity;
    model.details.expectedDeliveryDate = form.details.expectedDeliveryDate;
    model.details.contactPerson = form.details.contactPerson;
    model.details.contactPhone = form.details.contactPhone;
    form = model;
    Response response;
    try {
      if(factoryUid != null){
        response = await http$.post(OrderApis.requirementOrderNew,
            data: RequirementOrderModel.toJson(form),
            queryParameters: {'factory': factoryUid},
            options: Options(responseType: ResponseType.plain));
      }
      else if(factoryUid != null && privacy){
        response = await http$.post(OrderApis.requirementOrderNew,
            data: RequirementOrderModel.toJson(form),
            queryParameters: {'factory': factoryUid,'privacy':'true'},
            options: Options(responseType: ResponseType.plain));
      }else{
        response = await http$.post(OrderApis.requirementOrderNew,
            data: RequirementOrderModel.toJson(form),
            options: Options(responseType: ResponseType.plain));
      }

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
  Future<bool> doRecommendation(String code,String factoryId) async {
    Response response;
    try {
      response = await http$.put(OrderApis.doRecommendation(code,factoryId),
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

}
