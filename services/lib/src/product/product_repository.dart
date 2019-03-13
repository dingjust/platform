import 'package:models/models.dart';

/// 市
abstract class ProductRepository {
  Future<List<ProductModel>> list();

  //获取商品小类
  Future<List<CategoryModel>> cascadedCategories();

  //获取商品大类
  Future<List<CategoryModel>> majorCategories();
}
