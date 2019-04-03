import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'product_repository.dart';

/// 市
class ProductRepositoryImpl extends ProductRepository{

  @override
  Future<ProductsResponse> list(dynamic data,Map<String,dynamic> params) async{
    Response response = await http$.post(ProductApis.list,data: data,queryParameters: params);
    return ProductsResponse.fromJson(response.data);
  }

  @override
  Future<ProductsResponse> getProductsOfFactories(dynamic data,Map<String,dynamic> params) async{
    Response response = await http$.post(ProductApis.getProductsOfFactories,data: data,queryParameters: params);
    return ProductsResponse.fromJson(response.data);
  }

  @override
  Future<ProductsResponse> getProductsOfFactory(dynamic data, Map<String, Object> params,String uid) async{
    Response response = await http$.post(ProductApis.getProductsOfFactory(uid),data: data,queryParameters: params);
    return ProductsResponse.fromJson(response.data);
  }

  @override
  Future<ApparelProductModel> detail(String code) async{
    Response response = await http$.get(ProductApis.detail(code));
    return ApparelProductModel.fromJson(response.data);
  }

  @override
  Future<String> create(ApparelProductModel form) async{
    Response response = await http$.post(ProductApis.create,data: ApparelProductModel.toJson(form));
    return response.data;
  }

  @override
  Future<String> update(ApparelProductModel form) async{
    print(form.variants);
    form.variants.forEach((variant){
      print('${variant.color.name}===========${variant.size.name}');
    });
    Response response = await http$.put(ProductApis.update(form.code),data: ApparelProductModel.toJson(form));
    return response.data;
  }

  @override
  Future<String> delete(String code) async{
    Response response = await http$.delete(ProductApis.delete(code));
    return response.data;
  }

  @override
  Future<String> on(String code) async{
    Response response = await http$.put(ProductApis.on(code));
    return response.data;
  }

  @override
  Future<String> off(String code) async{
    Response response = await http$.put(ProductApis.off(code));
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

  @override
  Future<List<StyleModel>> styles() async{
    Response response;
    try{
      response = await http$.get(ProductApis.styles);
    }on DioError catch(e){
      print(e);
    }
    return response.data.map<StyleModel>((style)=>StyleModel.fromJson(style)).toList();
  }

  @override
  Future<SampleProductsResponse> samples(Map<String,dynamic> data) async {
    Response response = await http$.get(ProductApis.samples,data: data);
    return SampleProductsResponse.fromJson(response.data);
  }

  @override
  Future<SampleProductModel> getSample(String code)async {
   Response response = await http$.get(ProductApis.sampleDetail(code));
   return SampleProductModel.fromJson(response.data);
  }

  @override
  Future<String> createSample(SampleProductModel smaple) async{
    Response response = await http$.post(ProductApis.sampleCreate,data: SampleProductModel.toJson(smaple));
    return response.data;
  }

  @override
  Future<String> updateSample(SampleProductModel smaple) async{
    print(SampleProductModel.toJson(smaple));
    Response response = await http$.put(ProductApis.sampleUpdate,data: SampleProductModel.toJson(smaple));
    return response.data;
  }

  @override
  Future<SampleProductHistorysResponse> sampleHistorys(dynamic data, Map<String, dynamic> params) async{
    Response response = await http$.post(ProductApis.sampleHistorys,data: data,queryParameters: params);
    return SampleProductHistorysResponse.fromJson(response.data);
  }

  @override
  Future<SampleBorrowReturnHistoryModel> getSampleHistory(String id) async{
    Response response = await http$.get(ProductApis.getHistory(id));
    return SampleBorrowReturnHistoryModel.fromJson(response.data);
  }

  @override
  Future<String> createSampleHistory(SampleBorrowReturnHistoryModel sample) async{
    Response response = await http$.post(ProductApis.sampleHistoryCreate,data: SampleBorrowReturnHistoryModel.toJson(sample));
    return response.data;
  }

  @override
  Future<String> updateSampleHistory(SampleBorrowReturnHistoryModel sample)async {
    Response response = await http$.put(ProductApis.sampleHistoryUpdate(sample.id),data: SampleBorrowReturnHistoryModel.toJson(sample));
    return response.data;
  }

}
