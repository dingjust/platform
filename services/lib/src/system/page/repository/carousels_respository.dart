import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/system/page/response/carousels_response.dart';

///轮播图
class CarouselsRepository {
  ///产品首页轮播图
  Future<List<CarouselModel>> getCarouselsByType(CarouselType type) async {
    Response response;
    try {
      response = await http$.get(
        Apis.carousels(CarouselTypeValuedMap[type]),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      CarouselsResponse result = CarouselsResponse.fromJson(response.data);
      if (result.code == 1) {
        return result.data;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
