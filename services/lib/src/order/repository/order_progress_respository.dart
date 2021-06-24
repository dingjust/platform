import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

import '../../../services.dart';

///节点相关
class OrderProgressPlanRepository {
  ///获取节点方案列表
  static Future<OrderProgressPlanResponse> orderProgressPlans() async {
    Response response;
    try {
      response = await http$.post(
        OrderApis.progressPlans,
        data: {},
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      OrderProgressPlanResponse result =
          OrderProgressPlanResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///获取节点列表
  static Future<ProgressPhaseResponse> progressPhase() async {
    Response response;
    try {
      response = await http$.get(
        OrderApis.progressPhases,
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 0) {
        return null;
      }
      ProgressPhaseResponse result =
          ProgressPhaseResponse.fromJson(baseResponse.data);
      return result;
    } else {
      return null;
    }
  }

  ///创建节点方案
  static Future<BaseResponse> create(OrderProgressPlanModel form) async {
    Response response;
    try {
      response =
          await http$.post(OrderApis.progressPlansCreate, data: form.toJson());
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse model = BaseResponse.fromJson(response.data);
      return model;
    } else {
      return null;
    }
  }
}
