import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/amount_flow_response.dart';

//流水服务接口
class AmountFlowRepository {
  const AmountFlowRepository();

  @override
  Future<AmountFlowResponse> list(
      {dynamic data, Map<String, dynamic> params}) async {
    if (data == null) {
      data = {};
    }
    if (params == null) {
      params = {};
    }
    Response response;
    AmountFlowResponse result;
    try {
      response = await http$.post(UserApis.getAmountFlows,
          data: data, queryParameters: params);
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = AmountFlowResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  @override
  Future<AmountFlowModel> detail(String id) async {
    Response response = await http$.get(UserApis.getAmountFlow(id));
    return AmountFlowModel.fromJson(response.data);
  }

  //申请提现
  @override
  Future<bool> cashOut(double amount) async {
    Response response;
    bool result = false;
    try {
      response = await http$
          .put(UserApis.cashOut, queryParameters: {'amount': amount});
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = true;
    }
    return result;
  }

  //提现取消
  @override
  Future<bool> cashOutCanceled(String id) async {
    Response response;
    bool result = false;
    try {
      response = await http$.put(UserApis.cashOutCanceled(id));
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = true;
    }
    return result;
  }
}
