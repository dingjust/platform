import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/user/response/integral_response.dart';

///积分
class IntegralRepository {
  ///获取当前用户积分信息
  static Future<UserIntegralInfo> getIntegralInfo() async {
    Response response;
    UserIntegralInfo info;
    try {
      response = await http$.get(
        UserApis.userIntegralInfo,
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        Map<String, dynamic> result = baseResponse.data as Map<String, dynamic>;
        info = UserIntegralInfo.fromJson(result);
      }
    }
    return info;
  }

  ///获取当前用户积分记录
  static Future<IntegralHistoryResponse> getIntegraHistory(
      Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(UserApis.userIntegralHistory,
          data: {}, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      IntegralHistoryResponse result =
          IntegralHistoryResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///获取当前用户积分兑换记录
  static Future<IntegralExchangeHistoryResponse> getIntegraExchangeHistory(
      Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(UserApis.userIntegralExchangeHistory,
          data: {}, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      IntegralExchangeHistoryResponse result =
          IntegralExchangeHistoryResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///获取积分兑换规则
  static Future<IntegralExchangeRule> getIntegraExchangeRule() async {
    Response response;
    IntegralExchangeRule rule;
    try {
      response = await http$.get(UserApis.userIntegralExchangeRule);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        Map<String, dynamic> result = baseResponse.data as Map<String, dynamic>;
        rule = IntegralExchangeRule.fromJson(result);
      }
      return rule;
    } else {
      return null;
    }
  }

  ///获取积分兑换规则
  static Future<BaseResponse> integraExchange(
      Map<String, dynamic> param) async {
    Response response;
    BaseResponse result;
    try {
      response = await http$.post(UserApis.integralExchange, data: param);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = BaseResponse.fromJson(response.data);
    }
    return result;
  }
}
