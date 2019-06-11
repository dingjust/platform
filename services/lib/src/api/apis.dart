/// 应用API
class Apis {
  const Apis();

  /// 获取省份列表 GET
  static get regions => () {
        return '/{baseSiteId}/regions';
      };

  /// 获取省份下的城市列表 GET
  static get citiesForRegion => (region) {
        return '/{baseSiteId}/regions/$region/cities';
      };

  /// 获取城市下的区域列表 GET
  static get districtsForCity => (city) {
        return '/{baseSiteId}/cities/$city/districts';
      };

  /// 获取品牌明细 GET
  static get brand => (uid) {
        return '/{baseSiteId}/brands/$uid';
      };

  /// 获取品牌明细 GET
  static get brandUpdate => (uid) {
        return '/{baseSiteId}/brands/$uid';
      };

  /// 获取工厂明细 GET
  static get factory => (uid) {
        return '/{baseSiteId}/factories/$uid';
      };

  /// 获取工厂明细 GET
  static get factoryUpdate => (uid) {
        return '/{baseSiteId}/factories/$uid';
      };

  /// 图片上传
  static get upload => () {
        return '/{baseSiteId}/media/file/upload';
      };

  /// 文件删除
  static get mediaDelete => (id) {
        return '/{baseSiteId}/media/$id';
      };

  ///需求发布
  static get publishNewRequirement => () {
        return '/{baseSiteId}/orders/requirement/new';
      };

  //公司认证
  static get applyCertification => '/{baseSiteId}/companies/certification';

  /// 全部工厂列表Z
  static get factories => '/{baseSiteId}/factories';

  /// 经纬度
  static get factoriesForMap => '/{baseSiteId}/factories/map';

  //邀请报价工厂列表 传入需求单号
  static get requestQuoteFactories => (String code) {
        return '/{baseSiteId}/factories/requirement/$code';
      };

  /// 获取品牌的供应商列表
  static get factorySuppliers => '/{baseSiteId}/factories/getSuppliers';

  /// 获取工厂的供应商列表
  static get brandsSuppliers => '/{baseSiteId}/brands/getSuppliers';

  /// 检测版本
  static get appVersions => (String name, String platform) {
        return '/{baseSiteId}/appVersions/$name/$platform';
      };

  ///问题与帮助信息
  static get guideline => '/{baseSiteId}/guideline';

  ///问题与帮助信息详情
  static get guidelineDetail => (int id) {
        return '/{baseSiteId}/guideline/${id}';
      };

  static const String AMAP_TIP_API =
      'https://restapi.amap.com/v3/assistant/inputtips';

  static const String AMAP_AROUND_API =
      'https://restapi.amap.com/v3/place/around';

  ///分享-需求订单
  static get shareRequirement =>
          (String code) {
        return 'https://www.nbyjy.net/RequirementSharePage.html?code=$code&type=requirement';
      };

  ///分享-生产进度
  static get shareProductionProgress =>
          (String code) {
        return 'https://www.nbyjy.net/loading.html?code=$code&type=productionProgress';
      };

  ///分享-工厂
  static get shareFactory =>
          (String code) {
        return 'https://www.nbyjy.net/loading.html?code=$code&type=factory';
      };

  ///银行卡号查询
  static get cnBankCard =>
          (String cardNO) {
        return 'https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardNo=$cardNO&cardBinCheck=true';
      };

  ///银行LOGOAPI
  static get cnBankLOGO =>
          (String code) {
        return 'https://apimg.alipay.com/combo.png?d=cashier&t=$code';
      };
}
