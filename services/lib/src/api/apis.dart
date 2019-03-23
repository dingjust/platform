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
        return '/{baseSiteId}/b2b/brands/$uid';
      };

  /// 获取工厂明细 GET
  static get factory => (uid) {
        return '/{baseSiteId}/b2b/factories/$uid';
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
  static get publishNewRequirement => (){
    return '/{baseSiteId}/b2b/orders/requirement/new';
  };

  //公司认证
  static get applyCertification => '/{baseSiteId}/b2b/companies/certification';
}
