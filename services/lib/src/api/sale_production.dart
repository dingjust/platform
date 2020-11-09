///销售-生产Api
class SaleProductionApis {
  /// 外接订单
  static get outOrderPendingList =>
      '/{baseSiteId}/out/order/pending/accept/search';

  /// 外接订单详情
  static get outOrderPendingDetail => (id) {
        return '/{baseSiteId}/sales/production/order/$id';
      };

  /// 外接订单-拒单
  static get refuse => (id) {
        return '/{baseSiteId}/sales/production/order/reject/outboundOrder/$id';
      };

  ///外接订单-接单
  static get accept => '/{baseSiteId}/sales/production/order/save/order';

  static get outOrderList => '/{baseSiteId}/out/order/search';
}
