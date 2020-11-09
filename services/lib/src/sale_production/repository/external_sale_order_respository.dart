import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///外接订单
class ExternalSaleOrderRespository {
  /// 获取外接订单明细
  Future<SalesProductionOrderModel> getOrderDetail(int id) async {
    Response<Map<String, dynamic>> response =
        await http$.get(SaleProductionApis.outOrderPendingDetail(id));

    if (response.statusCode == 200 && response.data['code'] == 1) {
      SalesProductionOrderModel model =
          SalesProductionOrderModel.fromJson(response.data['data']);
      return model;
    } else
      return null;
  }

  ///拒单
  Future<BaseResponse> refuse(int id) async {
    Response<Map<String, dynamic>> response =
        await http$.get(SaleProductionApis.refuse(id));
    if (response.statusCode == 200 && response.data != null) {
      return BaseResponse.fromJson(response.data);
    } else
      return null;
  }

  ///接单
  Future<BaseResponse> accept(SalesProductionOrderModel order) async {
    Response<Map<String, dynamic>> response = await http$.post(
        SaleProductionApis.accept,
        data: order.toJson(),
        queryParameters: {'submitAudit': true});
    if (response.statusCode == 200 && response.data != null) {
      return BaseResponse.fromJson(response.data);
    } else
      return null;
  }
}
