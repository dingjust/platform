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

  ///获取风格
  static get styles => '/{baseSiteId}/styles/all';

  ///获取商品列表
  static get list => '/{baseSiteId}/b2b/products/apparel';

  ///根据code获取商品详情
  static get detail => (code) => '/{baseSiteId}/b2b/products/apparel/$code';

  ///创建商品
  static get create => '/{baseSiteId}/b2b/products/apparel/create';

  ///更新商品
  static get update => (code) => '/{baseSiteId}/b2b/products/apparel/$code';

  ///删除商品
  static get delete =>
      (code) => '/{baseSiteId}/b2b/products/apparel/$code/deleted';

  ///获取所有样衣
  static get samples => '/{baseSiteId}/b2b/products/sample/all';

  ///根据code获取样衣详情
  static get sampleDetail =>
      (code) => '/{baseSiteId}/b2b/products/sample/$code';

  ///创建样衣
  static get sampleCreate => '/{baseSiteId}/b2b/products/sample/create';

  ///更新样衣
  static get sampleUpdate => '/{baseSiteId}/b2b/products/sample/update';
  //获取样衣借还记录
  static get sampleHistorys =>
      '/{baseSiteId}/b2b/products/sampleCheckoutHist/search';
  //获取样衣借还记录明细

  //创建样衣借还记录
  static get sampleHistoryCreate =>
      '/{baseSiteId}/b2b/products/sampleCheckoutHist/create';
  //更新样衣借还记录
  static get sampleHistoryUpdate =>
      (id) => '/{baseSiteId}/b2b/products/sampleCheckoutHist/$id';
  //删除样衣借还记录
  static get sampleHistoryDelete =>
      (id) => '/{baseSiteId}/b2b/products/sampleCheckoutHist/$id';

  /// 看款下单（工厂款）
  static get factoriesApparel =>
      '/{baseSiteId}/b2b/products/apparel/factories';
}
