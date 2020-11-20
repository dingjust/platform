import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/user/response/cooperator_response.dart';

///合作商
abstract class CooperatorRepository {
  /// 获取合作商
  Future<CooperatorResponse> list({Map<String,dynamic> data, Map<String,dynamic> params});

  /// 获取合作商详情
  Future<CooperatorModel> getDetail(int id);

  /// 添加合作商
  Future<BaseResponse> appendCooperator(CooperatorModel form);
}
