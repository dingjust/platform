import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'product_repository.dart';

/// 市
class ProductRepositoryImpl extends ProductRepository{

  @override
  Future<ProductsResponse> list(dynamic data,Map<String,dynamic> params) async{
    Response response;
    try{
      response = await http$.post(ProductApis.list,data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return ProductsResponse.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<ProductsResponse> getProductsOfFactories(dynamic data,Map<String,dynamic> params) async{
    Response response;
    try{
      response = await http$.post(ProductApis.getProductsOfFactories,data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return ProductsResponse.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<ProductsResponse> getProductsOfFactory(dynamic data, Map<String, Object> params,String uid) async{
    Response response;
    try{
      response = await http$.post(ProductApis.getProductsOfFactory(uid),data: data,queryParameters: params);
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return ProductsResponse.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<ApparelProductModel> detail(String code) async{
    Response response;
    try{
      response = response = await http$.get(ProductApis.detail(code));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return ApparelProductModel.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<String> create(ApparelProductModel form) async{
    Response response;
    try{
      response = await http$.post(ProductApis.create,data: ApparelProductModel.toJson(form));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> update(ApparelProductModel form) async{
    Response response;
    try{
      response = await http$.put(ProductApis.update(form.code),data: ApparelProductModel.toJson(form));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> delete(String code) async{
    Response response;
    try{
      response = await http$.delete(ProductApis.delete(code));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> on(String code) async{
    Response response;
    try{
      response = await http$.put(ProductApis.on(code));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> off(String code) async{
    Response response;
    try{
      response = await http$.put(ProductApis.off(code));
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<List<CategoryModel>> cascadedCategories() async{
    Response response;
    try{
      response  = await http$.get(ProductApis.cascadedCategories);
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data.map<CategoryModel>((category){
        print(category);
        return CategoryModel.fromJson(category);
      }).toList();
//      List<CategoryModel> categoris = response.data.map<CategoryModel>((category){
//        print(category);
//        return CategoryModel.fromJson(category);
//      }).toList();
//      categoris = categoris.map((category1){
//        category1.children.forEach((category2){
//          category2.parent = category1;
//        });
//        return category1;
//      }).toList();
//      return categoris;
    }else{
      return null;
    }
  }


  @override
  Future<List<CategoryModel>> majorCategories() async{
    Response response;
    try{
      response  = await http$.get(ProductApis.majorCategories);
    } on DioError catch (e) {
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data.map<CategoryModel>((category){
        return CategoryModel.fromJson(category);
      }).toList();
    }else{
      return null;
    }
  }

  @override
  Future<List<ColorModel>> colors() async{
    Response response;
    try{
      response = await http$.get(ProductApis.colors);
    }on DioError catch(e){
      print(e);
    }

    if(response != null && response.statusCode == 200){
      return response.data.map<ColorModel>((color)=>ColorModel.fromJson(color)).toList();
    }else{
      return null;
    }

  }

  @override
  Future<List<SizeModel>> sizes() async{
    Response response;
    try{
      response = await http$.get(ProductApis.sizes);
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data.map<SizeModel>((size)=>SizeModel.fromJson(size)).toList();
    }else{
      return null;
    }

  }

  @override
  Future<List<StyleModel>> styles() async{
    Response response;
    try{
      response = await http$.get(ProductApis.styles);
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data.map<StyleModel>((style)=>StyleModel.fromJson(style)).toList();
    }else{
      return null;
    }

  }

  @override
  Future<SampleProductsResponse> samples(Map<String,dynamic> data) async {
    Response response;
    try{
      response = await http$.get(ProductApis.samples,data: data);
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return SampleProductsResponse.fromJson(response.data);
    }else{
      return null;
    }

  }

  @override
  Future<SampleProductModel> getSample(String code)async {
    Response response;
    try{
      response = await http$.get(ProductApis.sampleDetail(code));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return SampleProductModel.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<String> createSample(SampleProductModel smaple) async{
    Response response;
    try{
      response = await http$.post(ProductApis.sampleCreate,data: SampleProductModel.toJson(smaple));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> updateSample(SampleProductModel smaple) async{
    Response response;
    try{
      response = await http$.put(ProductApis.sampleUpdate,data: SampleProductModel.toJson(smaple));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<SampleProductHistorysResponse> sampleHistorys(dynamic data, Map<String, dynamic> params) async{
    Response response;
    try{
      response = await http$.post(ProductApis.sampleHistorys,data: data,queryParameters: params);
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return SampleProductHistorysResponse.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<SampleBorrowReturnHistoryModel> getSampleHistory(String id) async{
    Response response;
    try{
      response = await http$.get(ProductApis.getHistory(id));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return SampleBorrowReturnHistoryModel.fromJson(response.data);
    }else{
      return null;
    }
  }

  @override
  Future<String> createSampleHistory(SampleBorrowReturnHistoryModel sample) async{
    Response response;
    try{
      response = await http$.post(ProductApis.sampleHistoryCreate,data: SampleBorrowReturnHistoryModel.toJson(sample));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

  @override
  Future<String> updateSampleHistory(SampleBorrowReturnHistoryModel sample)async {
    Response response;
    try{
      response = await http$.put(ProductApis.sampleHistoryUpdate(sample.id),data: SampleBorrowReturnHistoryModel.toJson(sample));
    }on DioError catch(e){
      print(e);
    }
    if(response != null && response.statusCode == 200){
      return response.data;
    }else{
      return null;
    }
  }

}
