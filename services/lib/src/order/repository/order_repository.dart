import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class OrderRepositoryImpl {
  /// 发布需求
  Future<String> publishNewRequirement(RequirementOrderModel form) async {
    Map<String, dynamic> jsonMap = RequirementOrderModel.toJson(form);
    Response response = await http$.post(
      OrderApis.requirementOrderNew,
      data: jsonMap,
    );
    return response.data;
  }

  /// 获取订单明细
  static Future<RequirementOrderModel> getRequirementOrderDetail(
      String code) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.requirementOrderDetail(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      RequirementOrderModel model =
          RequirementOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }
}
