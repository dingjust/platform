/// 产品API
abstract class ProductApis {
  ///获取产品分类级联列表
  static get cascadedCategories => '/b2b/categories/cascaded';

  ///获取产品大类列表
  static get majorCategories => '/b2b/categories/majors';

  ///获取所有颜色
  static get colors => '/b2b/colors/all';

  ///获取尺码
  static get sizes => '/b2b/sizes/all';

  ///获取风格
  static get styles => '/b2b/styles/all';

  ///获取商品列表
  static get list => '/b2b/products/apparel';

  //品牌获取工厂的现款商品
  static get getProductsOfFactories => '/b2b/products/apparel/factories';

  //品牌获取工厂的现款商品
  static get getProductsOfFactory => (uid) => '/b2b/products/apparel/factories/$uid';

  ///根据code获取商品详情
  static get detail => (code) => '/b2b/products/apparel/$code';

  ///创建商品
  static get create => '/b2b/products/apparel/create';

  ///更新商品
  static get update => (code) => '/b2b/products/apparel/$code';

  ///删除商品
  static get delete =>
      (code) => '/b2b/products/apparel/$code/deleted';

  //商品上架
  static get on =>
          (code) => '/b2b/products/apparel/$code/on';
  //商品下架
  static get off =>
          (code) => '/b2b/products/apparel/$code/off';

  ///获取所有样衣
  static get samples => '/b2b/products/sample/all';

  ///根据code获取样衣详情
  static get sampleDetail =>
      (code) => '/b2b/products/sample/$code';

  ///创建样衣
  static get sampleCreate => '/b2b/products/sample/create';

  ///更新样衣
  static get sampleUpdate => '/b2b/products/sample/update';
  //获取样衣借还记录
  static get sampleHistorys =>
      '/b2b/products/sampleCheckoutHist/search';
  //获取样衣借还记录明细
  static get getHistory =>
      (id) => '/b2b/products/sampleCheckoutHist/$id';

  //创建样衣借还记录
  static get sampleHistoryCreate =>
      '/b2b/products/sampleCheckoutHist/create';
  //更新样衣借还记录
  static get sampleHistoryUpdate =>
      (id) => '/b2b/products/sampleCheckoutHist/update/$id';
  //删除样衣借还记录
  static get sampleHistoryDelete =>
      (id) => '/b2b/products/sampleCheckoutHist/$id';

  /// 看款下单（工厂款）
  static get factoriesApparel =>
      '/b2b/products/apparel/factories';
}
