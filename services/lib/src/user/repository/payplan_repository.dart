import 'dart:async';

import 'package:services/src/user/response/company_payplan_response.dart';

///账务
abstract class PayPlanRepository {
  /// 获取公司账务
  Future<CompanyPayPlanResponse> all();
}
