import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/common_response.dart';
import 'package:services/src/net/http_manager.dart';

class SalesOrderRespository {
  ///看款下单创建销售订单
  Future<CommonResponse> orderByProduct(SalesOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesCreateByProduct,
          data: SalesOrderModel.toJson(form),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return CommonResponse.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 获取订单明细
  Future<SalesOrderModel> getSalesOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(OrderApis.salesOrderDetails(code));

    if (response.statusCode == 200) {
      SalesOrderModel model = SalesOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }

  /// 更新物流信息（发货）
  Future<BaseMsg> delivery(String code, String trackingID,
      String carrierCode) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesOrderDelivery(code),
          data: {'trackingID': trackingID, 'carrierCode': carrierCode},
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 确认收货
  Future<BaseMsg> confirmReceived(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.salesOrderConfirmReceived(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 取消订单
  Future<BaseMsg> cancel(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.salesOrderCancel(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 申请退款
  Future<BaseMsg> refundApply(SalesOrderRefundInfoModel model) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesOrderRefundApply,
          data: SalesOrderRefundInfoModel.toJson(model),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 获取退款详情
  Future<SalesOrderRefundResponse> refundDetail(String code) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesOrderRefundInfo(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return SalesOrderRefundResponse.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 退款处理
  Future<BaseMsg> refundAudit(String code, bool result, String reason) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesOrderRefundAudit,
          data: {'code': code, 'agree': result, 'rejectReason': reason},
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }

  /// 撤销退款
  Future<BaseMsg> refundCancel(String code) async {
    Response response;
    try {
      response = await http$.get(OrderApis.salesOrderRefundCancel(code),
          options: Options(responseType: ResponseType.plain));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseMsg.fromJson(json.decode(response.data));
    } else {
      return null;
    }
  }
}
