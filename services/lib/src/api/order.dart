/// 订单API
class OrderApis {
  // ========需求=========

  /// 根据条件获取需求订单列表 POST
  static get requirementOrders => '/{baseSiteId}/b2b/orders/requirement';

  /// 急速发布需求/发布需求 POST
  static get requirementOrderNew => '/{baseSiteId}/b2b/orders/requirement/new';

  /// 重新发布需求，带出已有需求订单中的需求信息，??是否需要关联原始需求 POST
  static get requirementOrderCopyFrom => (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code/new';
      };

  /// 根据订单编号获取明细 GET
  static get requirementOrderDetail => (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code';
      };

  /// 根据订单编号获取报价单列表 GET
  static get requirementOrderQuotes => (code) {
        return '/{baseSiteId}/b2b/orders/requirement/$code/quotes';
      };

  /// 根据条件获取采购订单列表 POST
  static get purchaseOrders => '/{baseSiteId}/b2b/orders/purchase';

  /// 根据采购订单编号获取明细 GET
  static get purchaseOrderDetail => (code) {
        return '/{baseSiteId}/b2b/orders/purchase/$code';
      };

  //创建线下采购订单 POST
  static get purchaseOfflineOrders => '/{baseSiteId}/b2b/orders/purchase/offline';

  /// 根据条件获取报价单列表 POST
  static get quotes => '/{baseSiteId}/b2b/orders/quote';

  /// 根据报价单编号获取明细 GET
  static get quoteDetail => (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code';
      };

  /// 确认报价 PUT
  static get quoteApprove => (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code/approve';
      };

  /// 拒绝报价 PUT
  static get quoteReject => (code) {
        return '/{baseSiteId}/b2b/orders/quote/$code/reject';
      };
}
