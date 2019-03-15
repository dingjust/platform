/// 产品API
abstract class ProductApis {
  ///获取产品分类级联列表
  static get cascadedCategories => '/{baseSiteId}/b2b/categories/cascaded';
  ///获取产品大类列表
  static get majorCategories => '/{baseSiteId}/b2b/categories/majors';
  ///获取所有颜色
  static get colors => '/{baseSiteId}/colors/all';
  ///获取尺码
  static get sizes => '/{baseSiteId}/sizes/all';
  ///获取商品列表
  static get list => '/{baseSiteId}/b2b/products/apparel';
  ///创建商品
  static get create => '/{baseSiteId}/b2b/products/apparel/create';
}
