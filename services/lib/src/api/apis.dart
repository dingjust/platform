/// 应用API
class Apis {
  const Apis();

  /// 注册 POST
  static get register =>
          (type) {
        if (type != 'BRAND') {
          return '/{baseSiteId}/b2b/factory/register';
        }

        return '/{baseSiteId}/b2b/brand/register';
      };

  /// 获取省份列表 GET
  static get regions =>
          () {
        return '/{baseSiteId}/regions';
      };

  /// 获取省份下的城市列表 GET
  static get citiesForRegion =>
          (region) {
        return '/{baseSiteId}/regions/$region/cities';
      };

  /// 获取城市下的区域列表 GET
  static get districtsForCity =>
          (city) {
        return '/{baseSiteId}/cities/$city/districts';
      };

  /// 获取品牌明细 GET
  static get brand =>
          (uid) {
        return '/{baseSiteId}/b2b/brand/$uid';
      };

  /// 获取工厂明细 GET
  static get factory =>
          (uid) {
        return '/{baseSiteId}/b2b/factory/$uid';
      };

  /// 根据条件获取需求订单列表 POST
  static get requirementOrders =>
          () {
        return '/{baseSiteId}/b2b/orders/requirement';
      };

  /// 根据订单编号获取明细 GET
  static get requirementOrderDetail =>
          (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code';
      };

  /// 根据订单编号获取报价单列表 GET
  static get requirementOrderQuotes =>
          (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code/quotes';
      };

  /// 急速发布需求/发布需求 POST
  static get requirementOrderNew =>
          () {
        return '/{baseSiteId}/b2b/orders/requirement/new';
      };

  /// 重新发布需求，带出已有需求订单中的需求信息，??是否需要关联原始需求 POST
  static get requirementOrderCopyFrom =>
          (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code/new';
      };

  /// 根据条件获取采购订单列表 POST
  static get purchaseOrders =>
          () {
        return '/{baseSiteId}/b2b/orders/purchase';
      };

  /// 根据采购订单编号获取明细 GET
  static get purchaseOrderDetail =>
          (code) {
        return '/{baseSiteId}/b2b/orders/purchase/$code';
      };

  /// 根据条件获取报价单列表 POST
  static get quotes =>
          () {
        return '/{baseSiteId}/b2b/orders/quote';
      };

  /// 根据报价单编号获取明细 GET
  static get quoteDetail =>
          (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code';
      };

  /// 确认报价 PUT
  static get quoteApprove =>
          (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code/approve';
      };

  /// 拒绝报价 PUT
  static get quoteReject =>
          (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code/reject';
      };
}
