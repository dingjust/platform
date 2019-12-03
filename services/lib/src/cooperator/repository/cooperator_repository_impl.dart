import 'dart:async';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/cooperator_response.dart';

import 'package:services/src/cooperator/repository/cooperator_repository.dart';

///合作商
class CooperatorRepositoryImpl implements CooperatorRepository {
  /// 获取合作商列表
  Future<CooperatorResponse> list({Map<String,dynamic> data, Map<String,dynamic> params}) async {
    if(data == null){
      data = {};
    }
    if(params == null){
      params = {};
    }
    Response response;
    CooperatorResponse result;
    try {
      response = await http$.post(UserApis.cooperators, data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = CooperatorResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }
}
