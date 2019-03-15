import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'product_repository.dart';

/// 市
class ProductRepositoryImpl extends ProductRepository{

  @override
  Future<ProductsResponse> list(Map<String,dynamic> params,dynamic data) async{
    Response response = await http$.post(ProductApis.list,data: data,queryParameters: params);
    return ProductsResponse.fromJson(response.data);
  }

  @override
  Future<String> create(ApparelProductModel form) async{
    print(ApparelProductModel.toJson(form));
    Response response = await http$.post(ProductApis.create,data: ApparelProductModel.toJson(form));
    return response.data;
  }

  @override
  Future<List<CategoryModel>> cascadedCategories() async{
   Response response  = await http$.get(ProductApis.cascadedCategories);
    return response.data.map<CategoryModel>((category){
      return CategoryModel.fromJson(category);
    }).toList();
  }


  @override
  Future<List<CategoryModel>> majorCategories() async{
   Response response  = await http$.get(ProductApis.majorCategories);
    return response.data.map<CategoryModel>((category)=>CategoryModel.fromJson(category)).toList();
  }

  @override
  Future<List<ColorModel>> colors() async{
    Response response;
    try{
      response = await http$.get(ProductApis.colors);
    }on DioError catch(e){
      print(e);
    }

    return response.data.map<ColorModel>((color)=>ColorModel.fromJson(color)).toList();
  }

  @override
  Future<List<SizeModel>> sizes() async{
    Response response;
    try{
      response = await http$.get(ProductApis.sizes);
    }on DioError catch(e){
      print(e);
    }
    return response.data.map<SizeModel>((size)=>SizeModel.fromJson(size)).toList();
  }


}
