import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class PurchaseOrderRepository {
  //获取生产订单列表
  Future<PurchaseOrdersResponse> getPurchaseOrders(
      dynamic data, Map<String, dynamic> parames) async {
    PurchaseOrdersResponse purchaseOrdersResponse;
    Response response;
    try {
      response = await http$.post(OrderApis.purchaseOrders,
          data: data, queryParameters: parames);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      purchaseOrdersResponse = PurchaseOrdersResponse.fromJson(response.data);
    }

    return purchaseOrdersResponse;
  }

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
      response = await http$.get(OrderApis.getDetailsForUniqueCode(code),
          options: Options(headers: {'ignoreAlert': 1}));
    } on DioError catch (e) {
      return null;
    }
    if (response != null && response.statusCode == 200) {
      try {
        PurchaseOrderModel model = PurchaseOrderModel.fromJson(response.data);
        return model;
      } on Exception catch (e) {
        return null;
      }
    } else
      return null;
  }

  //修改生产进度时间或数量
  Future<bool> productionProgressUpload(
      String code, String id, ProductionProgressModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.productionProgressUpload(code, id),
          data: ProductionProgressModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //批量修改生产进度预计完成时间
  Future<bool> progressEstimatedDateUploads(String code, String id, List<ProductionProgressModel> forms) async {
//    List<Map<String, dynamic>> entriesToJson(List<PurchaseOrderEntryModel> entries) =>
//    entries.map((entry) => PurchaseOrderEntryModel.toJson(entry)).toList();
    List<Map<String,dynamic>> data = forms.map((progress) => ProductionProgressModel.toJson(progress)).toList();
    Response response;
    try {
      response = await http$.put(OrderApis.progressEstimatedDateUploads(code, id),
          data: data,
          options: Options(responseType: ResponseType.plain));

    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 修改订单尾款金额
  Future<bool> purchaseOrderBalanceUpdate(
      String code, PurchaseOrderModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.purchaseOrderBalanceUpdate(code),
          data: PurchaseOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 修改订单定金金额
  Future<bool> purchaseOrderDepositUpdate(
      String code, PurchaseOrderModel form) async {
    Response<String> response;
    try {
      response = await http$.put(
        OrderApis.purchaseOrderDepositUpdate(code),
        data: PurchaseOrderModel.toJson(form),
      );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///取消订单
  Future<bool> purchaseOrderCancelling(String code) async {
    Response<String> response;
    try {
      response = await http$.put(
        OrderApis.purchaseOrderCancelling(code),
      );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认发货
  Future<bool> purchaseOrderDelivering(
      String code, PurchaseOrderModel form) async {
    Response response;
    try {
      response = await http$.put(
        OrderApis.purchaseOrderDelivering(code),
        data: PurchaseOrderModel.toJson(form),
      );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认收货
  Future<bool> purchaseOrderShipped(
      String code, PurchaseOrderModel form) async {
    Response<String> response;
    try {
      response = await http$.put(
        OrderApis.purchaseOrderShipped(code),
        data: PurchaseOrderModel.toJson(form),
      );
    } on DioError catch (e) {
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
    try {
      response = await http$.put(OrderApis.generateUniqueCode(code),
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

  //关联唯一码
  Future<bool> linkUniqueCode(String code) async {
    Response<String> response;
    try {
      response = await http$.put(OrderApis.linkUniqueCode(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //确认生产
  Future<bool> confirmProduction(String code, PurchaseOrderModel form) async {
    Response<String> response;
    try {
      response = await http$.put(
        OrderApis.confirmProduction(code),
        data: PurchaseOrderModel.toJson(form),
      );
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //品牌修改送货地址
  Future<bool> updateAddress(String code, PurchaseOrderModel form) async {
    Response<String> response;
    try {
      response = await http$.put(OrderApis.updateAddress(code),
          data: PurchaseOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//工厂获取与该品牌的生产订单列表
  Future<PurchaseOrdersResponse> getPurchaseOrdersByBrand(
      String uid, Map<String, Object> params) async {
    Response response = await http$.post(
      OrderApis.purchaseOrders,
      data: {
        "purchasers": uid,
      },
      queryParameters: params,
    );

    PurchaseOrdersResponse purchaseResponse =
        PurchaseOrdersResponse.fromJson(response.data);
    return purchaseResponse;
  }

//品牌获取与该工厂的生产订单列表
  Future<PurchaseOrdersResponse> getPurchaseOrdersByFactory(
      String uid, Map<String, Object> params) async {
    Response response = await http$.post(
      OrderApis.purchaseOrders,
      data: {
        "belongTos": uid,
      },
      queryParameters: params,
    );

    PurchaseOrdersResponse purchaseResponse =
        PurchaseOrdersResponse.fromJson(response.data);
    return purchaseResponse;
  }
}
