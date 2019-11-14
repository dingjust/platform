import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/src/api/order.dart';
import 'package:services/src/net/http_manager.dart';

class CarrierState {
  List<CarrierModel> _carriers;

  Future<List<CarrierModel>> getCarriers() async {
    if (_carriers == null) {
      Response response;
      try {
        response = await http$.get(OrderApis.getCarriersAll);
      } on DioError catch (e) {
        print(e);
      }

      if (response != null && response.statusCode == 200) {
        _carriers = CarrierModel.fromJsonList(response.data);
        return _carriers;
      } else {
        return null;
      }
    } else {
      return _carriers;
    }
  }
}
