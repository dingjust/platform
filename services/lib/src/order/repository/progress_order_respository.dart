import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

///生产进度单据
class ProgressOrderRepository {
  ///创建生产进度单据
  Future<String> createProductionProgressOrder(
      int id, ProductionProgressOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.createProductionProgressOrder(id),
          data: ProductionProgressOrderModel.toJson(form),
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

  ///作废生产进度单据
  Future<String> deleteProductionProgressOrder(int id, int orderId) async {
    Response response;
    try {
      response = await http$.delete(
          OrderApis.deleteProductionProgressOrder(id, orderId),
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

  ///修改生产进度单据
  Future<String> updateProductionProgressOrder(
      int id, int orderId, ProductionProgressOrderModel form) async {
    Response response;
    try {
      response = await http$.put(
          OrderApis.updateProductionProgressOrder(id, orderId),
          data: ProductionProgressOrderModel.toJson(form),
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
