import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
abstract class ProductRepository {
  ///获取商品列表
  Future<ProductsResponse> list(Map<String,Object> params,dynamic data);

  //获取商品明细
  Future<ApparelProductModel> detail(String code);

  //创建商品
  Future<String> create(ApparelProductModel form);

  //编辑商品
  Future<String> update(ApparelProductModel form);

  //删除商品
  Future<String> delete(String code);

  //获取商品小类
  Future<List<CategoryModel>> cascadedCategories();

  //获取商品大类
  Future<List<CategoryModel>> majorCategories();
  
  //获取所有颜色
  Future<List<ColorModel>> colors();

  //获取所有尺码
  Future<List<SizeModel>> sizes();

  //获取所有风格
  Future<List<StyleModel>> styles();

}
