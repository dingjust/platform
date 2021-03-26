import 'package:dio/dio.dart';
import 'package:models/models.dart';

import '../../../services.dart';

class MaterielProductRepository {
  ///面辅料列表
  static Future<MaterielProductsResponse> getProducts(String api,
      {Map<String, dynamic> params = const {},
      Map<String, dynamic> data = const {}}) async {
    Response response;
    try {
      response = await http$.post(api, data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      MaterielProductsResponse result =
          MaterielProductsResponse.fromJson(response.data);
      return result;
    } else {
      return null;
    }
  }

  ///创建
  static Future<BaseResponse> create(MaterielProductModel form) async {
    Response response;
    try {
      response = await http$.post(ProductApis.materielProductCreate,
          data: form.toJson());
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    }
    return null;
  }

  ///详情
  static Future<MaterielProductModel> get(int id) async {
    Response response;
    try {
      response = await http$.get(
        ProductApis.getMaterielProduct(id),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      if (baseResponse.code == 1) {
        return MaterielProductModel.fromJson(baseResponse.data);
      }
    }
    return null;
  }

  ///删除
  static Future<BaseResponse> delete(int id) async {
    Response response;
    try {
      response = await http$.put(
        ProductApis.deleteMaterielProduct(id),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      BaseResponse baseResponse = BaseResponse.fromJson(response.data);
      return baseResponse;
    }
    return null;
  }
}
