import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/api/sale_production.dart';
import 'package:services/src/net/http_manager.dart';

///对账单
class ReconciliationOrderRespository {
  /// 对账单-详情
  static Future<FastReconciliationSheetModel> getDetail(int id) async {
    try {
      Response<Map<String, dynamic>> response = await http$.get(
        OrderApis.reconciliationOrderDetail(id),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['code'] == 1) {
          return FastReconciliationSheetModel.fromJson(response.data['data']);
        }
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  ///对账单-乙方确认
  static Future<BaseResponse> confirmByPartyB(int id) async {
    try {
      Response<Map<String, dynamic>> response = await http$.put(
        OrderApis.reconciliationOrderConfirmByPartyB(id),
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data['code'] == 1) {
          return BaseResponse.fromJson(response.data);
        }
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  ///创建对账
  static Future<BaseResponse> create(FastReconciliationSheetModel order) async {
    try {
      Response<Map<String, dynamic>> response = await http$.post(
          SaleProductionApis.createReconciliationOrder,
          data: order.toJson());
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///修改
  static Future<BaseResponse> update(FastReconciliationSheetModel order) async {
    try {
      Response<Map<String, dynamic>> response = await http$.put(
          SaleProductionApis.updateReconciliationOrder,
          data: order.toJson());
      if (response.statusCode == 200 && response.data != null) {
        return BaseResponse.fromJson(response.data);
      } else
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///取消
  static Future<BaseResponse> cancel(int id) async {
    try {
      Response<Map<String, dynamic>> response =
          await http$.put(SaleProductionApis.cancelReconciliationOrder(id));
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
