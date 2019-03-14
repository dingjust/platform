import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
abstract class ProductRepository {
  ///获取商品列表
  Future<ProductsResponse> list(Map<String,Object> params,dynamic data);

  //创建商品
  Future<String> create(ApparelProductModel form);

  //获取商品小类
  Future<List<CategoryModel>> cascadedCategories();

  //获取商品大类
  Future<List<CategoryModel>> majorCategories();
  
  //获取所有颜色
  Future<List<ColorModel>> colors();

  //获取所有尺码
  Future<List<SizeModel>> sizes();

}
