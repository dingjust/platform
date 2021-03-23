import 'package:dio/dio.dart';

import '../../../../services.dart';

class OrderProductRepository {
  ///看款下单产品
  static Future<ProductsResponse> getProducts(
      {Map<String, dynamic> params = const {},
      Map<String, dynamic> data = const {}}) async {
    Response response;
    try {
      response = await http$.post(ProductApis.factoriesApparel,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      ProductsResponse result = ProductsResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }
}
