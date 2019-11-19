import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

class DeliveryOrderRepository {
  ///创建收货单
  Future<String> createDeliveryOrder(
      String code, DeliveryOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.createDeliveryOrder(code),
          data: DeliveryOrderNoteModel.toJson(form),
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

  ///更新收货单
  Future<String> updateDeliveryOrder(DeliveryOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.updateDeliveryOrder(),
          data: DeliveryOrderNoteModel.toJson(form),
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

  ///创建并提交
  Future<String> createAndCommitDeliveryOrder(String code,
      DeliveryOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.createAndCommitDeliveryOrder(code),
          data: DeliveryOrderNoteModel.toJson(form),
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

  ///更新并提交
  Future<String> updateAndCommitDeliveryOrder(
      DeliveryOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.updateAndCommitDeliveryOrder(),
          data: DeliveryOrderNoteModel.toJson(form),
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

  ///撤回
  Future<String> recallDelivery(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.withdrawDeliveryOrder(code),
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

  ///确认收货单
  Future<String> confirmDeliveryOrder(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.confirmDeliveryOrder(code),
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

  ///拒绝收货单
  Future<String> rejectDeliveryOrder(String code) async {
    Response response;
    try {
      response = await http$.put(OrderApis.rejectDeliveryOrder(code),
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
}

///发货单
class ShippingOrderRepository {
  ///部分发货
  Future<String> partShippingOrder(String code,
      ShippingOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.createShippingOrder(code),
          data: ShippingOrderNoteModel.toJson(form),
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

  ///全部发货
  Future<String> fullShippingOrder(String code,
      ShippingOrderNoteModel form) async {
    Response response;
    try {
      response = await http$.put(OrderApis.confirmShipping(code),
          data: ShippingOrderNoteModel.toJson(form),
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
}
