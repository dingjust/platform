import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class PurchaseOrderRepository {
  /// 创建线下采购订单
  Future<String> offlinePurchaseOrder(PurchaseOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.purchaseOfflineOrders,
          data: PurchaseOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.toString();
    } else {
      return null;
    }
  }

  //创建线上生产订单
  Future<String> onlinePurchaseOrder(
      String quote, PurchaseOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.purchaseOnlineOrders(quote),
          data: PurchaseOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
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
      PurchaseOrderModel model = PurchaseOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  //根据唯一码获取订单明细
  Future<PurchaseOrderModel> getDetailsForUniqueCode(String code) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(OrderApis.getDetailsForUniqueCode(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      PurchaseOrderModel model = PurchaseOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }


    //修改生产进度时间或数量
    Future<bool> productionProgressUpload(String code, String id, ProductionProgressModel form) async {
      Response response;
      try{
        response = await http$.put(
          OrderApis.productionProgressUpload(code,id),
          data: ProductionProgressModel.toJson(form),
            options: Options(responseType: ResponseType.plain)
        );
      }on DioError catch(e){
        print(e);
      }
      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }


  /// 修改订单定金金额
  Future<bool> purchaseOrderBalanceUpdate(String code , PurchaseOrderModel form) async {
      Response response;
      try{
        response =  await http$.put(
          OrderApis.purchaseOrderBalanceUpdate(code),
          data: PurchaseOrderModel.toJson(form),
            options: Options(responseType: ResponseType.plain)
        );
      }on DioError catch(e){
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    }

  /// 修改订单尾款金额
  Future<bool> purchaseOrderDepositUpdate(String code , PurchaseOrderModel form) async {
    Response<String> response;
    try{
      response =  await http$.put(
        OrderApis.purchaseOrderDepositUpdate(code),
        data: PurchaseOrderModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///取消订单
  Future<bool> purchaseOrderCancelling(String code , PurchaseOrderModel form) async {
    Response<String> response;
    try{
      response =  await http$.put(
        OrderApis.purchaseOrderCancelling(code),
        data: PurchaseOrderModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认发货
  Future<String> purchaseOrderDelivering(String code , PurchaseOrderModel form) async {
    Response<String> response;
    String message;
    try{
      response =  await http$.put(
        OrderApis.purchaseOrderDelivering(code),
        data: PurchaseOrderModel.toJson(form),
      );
    }on DioError catch(e){
      message = e.message;
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return message;
    }
  }

  //确认收货
  Future<bool> purchaseOrderShipped(String code , PurchaseOrderModel form) async {
    Response<String> response;
    try{
      response =  await http$.put(
        OrderApis.purchaseOrderShipped(code),
        data: PurchaseOrderModel.toJson(form),
      );
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //生成唯一码
  Future<String> generateUniqueCode(String code) async {
    Response<String> response;
    try{
      response =  await http$.put(OrderApis.generateUniqueCode(code),
          options: Options(responseType: ResponseType.plain));
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  //关联唯一码
  Future<bool> linkUniqueCode(String code) async {
    Response<String> response;
    try{
      response =  await http$.put(
        OrderApis.linkUniqueCode(code),
          options: Options(responseType: ResponseType.plain));
    }on DioError catch(e){
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }


}
