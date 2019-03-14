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
}
