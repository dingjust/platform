import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

class SalesOrderRespository {
  ///看款下单创建销售订单
  Future<String> orderByProduct(SalesOrderModel form) async {
    Response response;
    try {
      response = await http$.post(OrderApis.salesCreateByProduct,
          data: SalesOrderModel.toJson(form),
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
  Future<SalesOrderModel> getSalesOrderDetail(String code) async {
    Response<Map<String, dynamic>> response =
    await http$.get(OrderApis.salesOrderDetails(code));

    if (response.statusCode == 200) {
      SalesOrderModel model = SalesOrderModel.fromJson(response.data);
      return model;
    } else
      return null;
  }
}
