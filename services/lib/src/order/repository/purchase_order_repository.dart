import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class PurchaseOrderRepository {
  /// 创建线下采购订单
    Future<String> offlinePurchaseOrder(PurchaseOrderModel form) async {
    Response<String> response;
    try{
      await http$.post(
        OrderApis.purchaseOfflineOrders,
        data: PurchaseOrderModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //创建线上生产订单
    Future<String> onlinePurchaseOrder(String quote , PurchaseOrderModel form) async {
      Response<String> response;
      try{
        await http$.post(
          OrderApis.purchaseOnlineOrders(quote),
          data: PurchaseOrderModel.toJson(form),
        );
      }on DioError catch(e){
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    }

    /// 获取订单明细
    Future<PurchaseOrderModel> getPurchaseOrderDetail(String code) async {
      Response<Map<String, dynamic>> response;
      try {
        response = await http$.get(OrderApis.purchaseOrderDetail(code));
      } on DioError catch (e) {
        print(e);
      }
      if (response != null && response.statusCode == 200) {
        PurchaseOrderModel model =
        PurchaseOrderModel.fromJson(response.data);
        return model;
      } else
        return null;
    }

}
