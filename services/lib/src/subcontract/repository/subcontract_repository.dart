import 'dart:async';

import 'package:models/models.dart';
import 'package:services/src/subcontract/response/subcontract_response.dart';

///转包
abstract class SubContractRepository {
  /// 获取全部工厂转包
  Future<SubContractResponse> getSubcontractsByAllFactory({Map<String,dynamic> data, Map<String,dynamic> params});

  /// 获取我的转包
  Future<SubContractResponse> getSubcontracts({Map<String,dynamic> data, Map<String,dynamic> params});

  /// 获取转包详情
  Future<SubContractModel> getSubContract(String code);

  /// 创建转包
  Future<String> createSubContract(SubContractModel form);

  /// 创建转包
  Future<String> cancleSubContract(String code);
}
