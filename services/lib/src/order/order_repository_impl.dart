import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  Future<String> publishNewRequirement(RequirementOrderModel form) async {
//    print(RequirementOrderModel.toJson(form));
    Map<String, dynamic> jsonMap = RequirementOrderModel.toJson(form);
    print(jsonMap);
    Response response = await http$.post(
      OrderApis.requirementOrderNew,
      data: jsonMap,
    );
    return response.data;
  }
}
