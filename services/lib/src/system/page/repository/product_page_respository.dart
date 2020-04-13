import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/system/page/response/product_page_response.dart';

///产品首页
class ProductPageRepository {
  ///创建收货单
  Future<List<PlateItem>> productHomePlateItems() async {
    Response response;
    try {
      response = await http$.get(
        Apis.productHomePageItems,
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      List<dynamic> datas = response.data;
      return datas
          .map((data) => PlateItem.fromJson(data as Map<String, dynamic>))
          .toList();
    } else {
      return null;
    }
  }
}
