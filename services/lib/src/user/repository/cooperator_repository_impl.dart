import 'dart:async';

import 'package:dio/dio.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/cooperator_response.dart';

import 'cooperator_repository.dart';

///合作商
class CooperatorRepositoryImpl implements CooperatorRepository {
  /// 公司订单报表
  Future<CooperatorResponse> all() async {
    Response response;
    CooperatorResponse result;
    try {
      response = await http$.post(UserApis.cooperators, data: {});
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
