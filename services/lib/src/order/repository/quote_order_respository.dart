import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/order/response/order_response.dart';

class QuoteOrderRepository {
  /// 查询需求报价单
  // Future<List<QuoteModel>> getQuotesByRequirement(
  //     {String requirementOrderCode, int size, int page}) async {
  //   Map conditionMap = {'requirementOrderRef': requirementOrderCode};
  //   Response<Map<String, dynamic>> response;
  //   try {
  //     response = await http$.post(OrderApis.quotes,
  //         data: conditionMap, queryParameters: {'page': page, 'size': size});
  //   } on DioError catch (e) {
  //     print(e);
  //   }
  //   if (response != null && response.statusCode == 200) {
  //     QuoteOrdersResponse ordersResponse =
  //         QuoteOrdersResponse.fromJson(response.data);
  //     return ordersResponse.content;
  //   } else
  //     return null;
  // }
}
