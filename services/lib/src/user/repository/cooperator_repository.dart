import 'dart:async';

import 'package:services/src/user/response/cooperator_response.dart';

///合作商
abstract class CooperatorRepository {
  /// 获取合作商
  Future<CooperatorResponse> all();
}
