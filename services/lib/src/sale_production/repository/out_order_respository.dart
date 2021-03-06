import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///外发订单
class OutOrderRespository {
  ///创建外发订单
  static Future<BaseResponse> saveOutOrder(
      bool submitAudit, SalesProductionOrderModel order) async {
    //处理数据
    order.payPlan.id = null;
    order.payPlan.payPlanItems.forEach((element) {
      element.id = null;
    });
    order.taskOrderEntries.forEach((element) {
      element.id = null;
      element?.progressPlan?.id = null;
      element?.progressPlan?.productionProgresses?.forEach((progress) {
        progress.id = null;
      });
    });

    try {
      Response<Map<String, dynamic>> response = await http$.post(
          SaleProductionApis.createOutOrder,
          data: order.toJson(),
          queryParameters: {'submitAudit': submitAudit});
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
