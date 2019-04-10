/// 产品API
abstract class ProductApis {
  ///获取产品分类级联列表
  static get cascadedCategories => '/{baseSiteId}/categories/cascaded';

  ///获取产品大类列表
  static get majorCategories => '/{baseSiteId}/categories/majors';

  ///获取所有颜色
  static get colors => '/{baseSiteId}/colors/all';

  ///获取尺码
  static get sizes => '/{baseSiteId}/sizes/all';

  ///获取风格
  static get styles => '/{baseSiteId}/styles/all';

  ///获取商品列表
  static get list => '/{baseSiteId}/products/apparel';

  //品牌获取工厂的现款商品
  static get getProductsOfFactories => '/{baseSiteId}/products/apparel/factories';

  //品牌获取工厂的现款商品
  static get getProductsOfFactory => (uid) => '/{baseSiteId}/products/apparel/factories/$uid';

  ///根据code获取商品详情
  static get detail => (code) => '/{baseSiteId}/products/apparel/$code';

  ///创建商品
  static get create => '/{baseSiteId}/products/apparel/create';

  ///更新商品
  static get update => (code) => '/{baseSiteId}/products/apparel/$code';

  ///删除商品
  static get delete =>
      (code) => '/{baseSiteId}/products/apparel/$code/deleted';

  //商品上架
  static get on =>
          (code) => '/{baseSiteId}/products/apparel/$code/on';
  //商品下架
  static get off =>
          (code) => '/{baseSiteId}/products/apparel/$code/off';

  ///获取所有样衣
  static get samples => '/{baseSiteId}/products/sample/all';

  ///根据code获取样衣详情
  static get sampleDetail =>
      (code) => '/{baseSiteId}/products/sample/$code';

  ///创建样衣
  static get sampleCreate => '/{baseSiteId}/products/sample/create';

  ///更新样衣
  static get sampleUpdate => '/{baseSiteId}/products/sample/update';
  //获取样衣借还记录
  static get sampleHistorys =>
      '/{baseSiteId}/products/sampleCheckoutHist/search';
  //获取样衣借还记录明细
  static get getHistory =>
      (id) => '/{baseSiteId}/products/sampleCheckoutHist/$id';

  //创建样衣借还记录
  static get sampleHistoryCreate =>
      '/{baseSiteId}/products/sampleCheckoutHist/create';
  //更新样衣借还记录
  static get sampleHistoryUpdate =>
      (id) => '/{baseSiteId}/products/sampleCheckoutHist/update/$id';
  //删除样衣借还记录
  static get sampleHistoryDelete =>
      (id) => '/{baseSiteId}/products/sampleCheckoutHist/$id';

  /// 看款下单（工厂款）
  static get factoriesApparel =>
      '/{baseSiteId}/products/apparel/factories';
}
