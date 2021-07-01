import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/common/response.dart';
import 'package:services/src/net/http_manager.dart';

///外接订单
class ExternalSaleOrderRespository {
  ///创建外接订单
  static Future<BaseResponse> save(
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
          SaleProductionApis.createExternalSaleOrder,
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
    try {
      Response<Map<String, dynamic>> response = await http$.post(
          SaleProductionApis.accept,
          data: order.toJson(),
          queryParameters: {'submitAudit': true});
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// 外接订单唯一码检索
  Future<SalesProductionOrderModel> uniqueCodePreview(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(SaleProductionApis.uniqueCodePreview(code));

    if (response.statusCode == 200 && response.data['code'] == 1) {
      SalesProductionOrderModel model =
      SalesProductionOrderModel.fromJson(response.data['data']);
      return model;
    } else
      return null;
  }

  ///外接订单唯一码导入
  Future<BaseResponse> uniqueCodeImport(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(SaleProductionApis.uniqueCodeImport(code));
    if (response.statusCode == 200 && response.data != null) {
      return BaseResponse.fromJson(response.data);
    } else
      return null;
  }

  /// 外发订单二维码检索
  Future<SalesProductionOrderModel> qrCodePreview(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(SaleProductionApis.qrCodePreview(code));

    if (response.statusCode == 200 && response.data['code'] == 1) {
      SalesProductionOrderModel model =
      SalesProductionOrderModel.fromJson(response.data['data']);
      return model;
    } else
      return null;
  }

  ///外接订单唯一码导入
  Future<BaseResponse> qrCodeImport({String code, int merchandiser}) async {
    Response<Map<String, dynamic>> response =
    await http$.post(SaleProductionApis.qrCodeImport(code), data: {
      'merchandiser': {'id': merchandiser}
    });
    if (response.statusCode == 200 && response.data != null) {
      return BaseResponse.fromJson(response.data);
    } else
      return null;
  }
}
