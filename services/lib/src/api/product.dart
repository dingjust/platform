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
      (id) => '/{baseSiteId}/materiel/product/update/state/$id?state=DELETED';

  ///款式列表
  static get sampleProducts => '/{baseSiteId}/sample/clothes';

  ///款式详情(详情-get 更新-put)
  static get sampleProduct => (code) => '/{baseSiteId}/sample/clothes/$code';

  ///款式创建
  static get sampleCreate => '/{baseSiteId}/sample/clothes/create';
}
