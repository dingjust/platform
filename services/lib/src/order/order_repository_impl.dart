import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  //需求发布
  @override
  Future<String> publishNewRequirement(RequirementOrderModel form) async {
//    print(RequirementOrderModel.toJson(form));
    Map<String, dynamic> jsonMap = RequirementOrderModel.toJson(form);
    print(jsonMap);
    Response response = await http$.post(
      OrderApis.requirementOrderNew,
      data: {},
    );
    return response.data;
  }

  // 获取订单明细
  @override
  Future<RequirementOrderModel> getRequirementOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(OrderApis.requirementOrderDetail(code));

    if (response.statusCode == 200) {
      RequirementOrderModel model =
      RequirementOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }
}
