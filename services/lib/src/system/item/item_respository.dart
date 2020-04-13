import 'package:dio/dio.dart';

import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class ItemRepository {
  ///item详情点击
  Future onDetail(int pk) async {
    Response response;
    try {
      response = await http$.put(
        Apis.itemDetail(pk),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return 1;
    } else {
      return 0;
    }
  }
}
