import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'product_repository.dart';

/// 市
class ProductRepositoryImpl extends ProductRepository{

  @override
  Future<List<ProductModel>> list() {
   return null;
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


}
