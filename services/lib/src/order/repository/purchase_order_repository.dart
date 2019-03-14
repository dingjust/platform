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
}
