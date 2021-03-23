import 'dart:async';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/home/factory/response/factory_response.dart';

class FactoryRepository {
  ///获取工厂
  static Future<FactoriesResponse> getFactories(
      {Map<String, dynamic> params = const {},
      Map<String, dynamic> data = const {}}) async {
    Response response;
    try {
      response =
          await http$.post(Apis.factories, data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      FactoriesResponse result = FactoriesResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }
}
