import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'product_repository.dart';

/// 市
class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<ProductsResponse> list(
      dynamic data, Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(ProductApis.list,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<ProductsResponse> getProductsOfFactories(
      dynamic data, Map<String, dynamic> params) async {
    Response response;
    try {
      response = await http$.post(ProductApis.getProductsOfFactories,
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<ProductsResponse> getProductsOfFactory(
      dynamic data, Map<String, Object> params, String uid) async {
    Response response;
    try {
      response = await http$.post(ProductApis.getProductsOfFactory(uid),
          data: data, queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<ApparelProductModel> detail(String code) async {
    Response response;
    try {
      response = await http$.get(ProductApis.detail(code),
          data: {'fields': ApparelProductOptions.DEFAULT});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return ApparelProductModel.fromJson(response.data);
    } else {
      return null;
    }
  }

  @override
  Future<bool> create(ApparelProductModel form) async {
    Response response;
    try {
      response = await http$.post(ProductApis.create,
          data: ApparelProductModel.toJson(form));
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

  @override
  Future<bool> update(ApparelProductModel form) async {
    Response response;
    try {
      response = await http$.put(ProductApis.update(form.code),
          data: ApparelProductModel.toJson(form));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> delete(String code) async {
    Response response;
    try {
      response = await http$.delete(ProductApis.delete(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Future<String> on(String code) async {
    Response response;
    try {
      response = await http$.put(ProductApis.on(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Future<String> off(String code) async {
    Response response;
    try {
      response = await http$.put(ProductApis.off(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> cascadedCategories() async {
    Response response;
    try {
      response = await http$.get(ProductApis.cascadedCategories);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data.map<CategoryModel>((category) {
        return CategoryModel.fromJson(category);
      }).toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> majorCategories() async {
    Response response;
    try {
      response = await http$.get(ProductApis.majorCategories);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data.map<CategoryModel>((category) {
        return CategoryModel.fromJson(category);
      }).toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<ColorModel>> colors() async {
    Response response;
    try {
      response = await http$.get(ProductApis.colors);
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return response.data
          .map<ColorModel>((color) => ColorModel.fromJson(color))
          .toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<SizeModel>> sizes() async {
    Response response;
    try {
      response = await http$.get(ProductApis.sizes);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data
          .map<SizeModel>((size) => SizeModel.fromJson(size))
          .toList();
    } else {
      return null;
    }
  }

  @override
  Future<List<StyleModel>> styles() async {
    Response response;
    try {
      response = await http$.get(ProductApis.styles);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data
          .map<StyleModel>((style) => StyleModel.fromJson(style))
          .toList();
    } else {
      return null;
    }
  }
}
