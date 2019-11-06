import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class CapacityRepository {
  ///创建产能
  Future<BaseMsg> save(FactoryCapacityModel model) async {
    Response response;
    try {
      response = await http$.post(CapacityApis.save,
          data: FactoryCapacityModel.toJson(model));
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
