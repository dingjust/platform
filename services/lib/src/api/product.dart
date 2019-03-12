/// 产品API
abstract class ProductApis {
  ///获取产品小类列表
  static get cascadedCategories => '/{baseSiteId}/b2b/categories/cascaded';
  ///获取产品大类列表
  static get majorCategories => '/{baseSiteId}/b2b/categories/majors';
}
