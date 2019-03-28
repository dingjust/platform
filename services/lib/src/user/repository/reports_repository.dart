import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class ReportsRepository {
  /// 公司订单报表
  Future<Reports> report() async {
    Response response;
    Reports result;
    try {
      response = await http$.post(UserApis.reports, data: {});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = Reports.fromJson(response.data);
    } else {
      result = null;
    }
    return result;
  }
}
