import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/repository/payplan_repository.dart';
import 'package:services/src/user/response/company_payplan_response.dart';

///账务
class PayPlanRepositoryImpl implements PayPlanRepository {
  @override
  Future<CompanyPayPlanResponse> all() async {
    Response response;
    CompanyPayPlanResponse result;
    try {
      response = await http$.post(UserApis.payplans,
          data: {}, queryParameters: {'page': 0, 'size': 999});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = CompanyPayPlanResponse.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }

  static Future<String> create(CompanyPayPlanModel form) async {
    Response response;
    try {
      response = await http$.post(
        UserApis.payplansCreate,
        data: CompanyPayPlanModel.toJson(form),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return 'success';
    }
    return null;
  }
}
