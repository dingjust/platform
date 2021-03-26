/// 产品API
abstract class ProductApis {
  ///获取产品分类级联列表
  static get cascadedCategories => '/{baseSiteId}/categories/cascaded';

  ///获取面料类别列表
  static get majorCategories => '/{baseSiteId}/categories/majors';

  ///获取所有颜色
  static get colors => '/{baseSiteId}/colors/all';

  ///获取尺码
  static get sizes => '/{baseSiteId}/sizes/all';

  ///获取风格
  static get styles => '/{baseSiteId}/styles/all';

  ///获取产品列表
  static get list => '/{baseSiteId}/products/apparel';

  //品牌获取所有工厂的现款产品
  static get getProductsOfFactories =>
      '/{baseSiteId}/products/apparel/factories';

  //品牌获取工厂的现款产品
  static get getProductsOfFactory =>
      (uid) => '/{baseSiteId}/products/apparel/factories/$uid';

  ///根据code获取产品详情
  static get detail => (code) => '/{baseSiteId}/products/apparel/$code';

  ///创建产品
  static get create => '/{baseSiteId}/products/apparel/create';

  ///更新产品
  static get update => (code) => '/{baseSiteId}/products/apparel/$code';

  ///删除产品
  static get delete => (code) => '/{baseSiteId}/products/apparel/$code/deleted';

  //产品上架
  static get on => (code) => '/{baseSiteId}/products/apparel/$code/on';
  //产品下架
  static get off => (code) => '/{baseSiteId}/products/apparel/$code/off';

  ///获取所有样衣
  static get samples => '/{baseSiteId}/products/sample/all';

  ///根据code获取样衣详情
  static get sampleDetail => (code) => '/{baseSiteId}/products/sample/$code';

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
  static get factoriesApparel => '/{baseSiteId}/products/apparel/factories';

  /// 创建面辅料
  static get materielProductCreate => '/{baseSiteId}/materiel/product';

  /// 公司面辅料查询
  static get materielProductSearch => '/{baseSiteId}/materiel/product/search';

  /// 所有在售
  static get materielProductAll => '/{baseSiteId}/materiel/product/all';

  /// 面辅料详情
  static get getMaterielProduct => (id) => '/{baseSiteId}/materiel/product/$id';

  /// 面辅料删除
  static get deleteMaterielProduct =>
          (
          id) => '/{baseSiteId}/materiel/product/update/state/$id?state=DELETED';
}
