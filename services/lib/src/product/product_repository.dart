import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
abstract class ProductRepository {
  ///获取产品列表
  Future<ProductsResponse> list(dynamic data,Map<String,Object> params);

  //品牌获取工厂的现款产品
  Future<ProductsResponse> getProductsOfFactories(dynamic data,Map<String,Object> params);

  //品牌获取工厂的现款产品
  Future<ProductsResponse> getProductsOfFactory(dynamic data,Map<String,Object> params,String uid);

  //获取产品明细
  Future<ApparelProductModel> detail(String code);

  //创建产品
  Future<String> create(ApparelProductModel form);

  //编辑产品
  Future<String> update(ApparelProductModel form);

  //删除产品
  Future<String> delete(String code);

  //产品上架
  Future<String> on(String code);
  //产品下架
  Future<String> off(String code);

  //获取产品小类
  Future<List<CategoryModel>> cascadedCategories();

  //获取面料类别
  Future<List<CategoryModel>> majorCategories();
  
  //获取所有颜色
  Future<List<ColorModel>> colors();

  //获取所有尺码
  Future<List<SizeModel>> sizes();

  //获取所有风格
  Future<List<StyleModel>> styles();

  //获取样衣列表
  Future<SampleProductsResponse> samples(Map<String,dynamic> data);

  //获取样衣明细
  Future<SampleProductModel> getSample(String code);

  //创建样衣
  Future<String> createSample(SampleProductModel sample);

  //更新样衣
  Future<String> updateSample(SampleProductModel smaple);

  //获取样衣记录列表
  Future<SampleProductHistorysResponse> sampleHistorys(dynamic data, Map<String, dynamic> params);

  //获取样衣记录明细
  Future<SampleBorrowReturnHistoryModel> getSampleHistory(String id);

  //创建样衣记录
  Future<String> createSampleHistory(SampleBorrowReturnHistoryModel sample);

  //更新样衣记录
  Future<String> updateSampleHistory(SampleBorrowReturnHistoryModel sample);
}
