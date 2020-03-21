import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

class SalesOrderRespository {
  //看款下单创建销售订单
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
}
