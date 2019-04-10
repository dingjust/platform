/// 应用API
class Apis {
  const Apis();

  /// 获取省份列表 GET
  static get regions => () {
        return '/b2b/regions';
      };

  /// 获取省份下的城市列表 GET
  static get citiesForRegion => (region) {
        return '/b2b/regions/$region/cities';
      };

  /// 获取城市下的区域列表 GET
  static get districtsForCity => (city) {
        return '/b2b/cities/$city/districts';
      };

  /// 获取品牌明细 GET
  static get brand => (uid) {
        return '/b2b/brands/$uid';
      };

  /// 获取品牌明细 GET
  static get brandUpdate => (uid) {
        return '/b2b/brands/$uid';
      };

  /// 获取工厂明细 GET
  static get factory => (uid) {
        return '/b2b/factories/$uid';
      };

  /// 获取工厂明细 GET
  static get factoryUpdate => (uid) {
        return '/b2b/factories/$uid';
      };

  /// 图片上传
  static get upload => () {
        return '/b2b/media/file/upload';
      };

  /// 文件删除
  static get mediaDelete => (id) {
        return '/b2b/media/$id';
      };

  ///需求发布
  static get publishNewRequirement => () {
        return '/b2b/orders/requirement/new';
      };

  //公司认证
  static get applyCertification => '/b2b/companies/certification';

  /// 全部工厂列表
  static get factories => '/b2b/factories';

  //邀请报价工厂列表 传入需求单号
  static get requestQuoteFactories => (String code) {
     return '/b2b/factories/requirement/$code';
  };

    /// 获取品牌的供应商列表
    static get factorySuppliers => '/b2b/factories/getSuppliers';
    /// 获取工厂的供应商列表
    static get brandsSuppliers => '/b2b/brands/getSuppliers';
}
