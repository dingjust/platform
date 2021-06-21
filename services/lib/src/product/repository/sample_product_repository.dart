import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/net/http_manager.dart';

class SampleProductRepository {
  //创建
  static Future<bool> create(SampleProductModel form) async {
    Response response;
    try {
      response =
          await http$.post(ProductApis.sampleCreate, data: form.toJson());
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseMsg model = BaseMsg.fromJson(response.data);
      return model.code == 1;
    } else {
      return false;
    }
  }

  //更新
  static Future<bool> update(SampleProductModel form) async {
    Response response;
    try {
      response = await http$.put(ProductApis.sampleProduct(form.code),
          data: form.toJson());
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  ///款式列表
  static Future<SampleProductsResponse> list(
      dynamic data, Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(ProductApis.sampleProducts,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      SampleProductsResponse result =
          SampleProductsResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///详情
  static Future<SampleProductModel> getDetail(String code) async {
    Response response;
    try {
      response = await http$.get(ProductApis.sampleProduct(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      SampleProductModel result = SampleProductModel.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }
}
