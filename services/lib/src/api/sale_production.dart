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

  ///外接订单-唯一码-检索
  static get uniqueCodePreview => (code) {
        return '/{baseSiteId}/out/order/preview/$code';
      };

  ///外接订单-唯一码-导入
  static get uniqueCodeImport => (code) {
        return '/{baseSiteId}/sales/production/order/create/from/uniqueCode/$code';
      };

  ///外发订单-二维码-检索
  static get qrCodePreview => (code) {
        return '/{baseSiteId}/sales/production/order/preview/$code';
      };

  ///外发订单-二维码-导入
  static get qrCodeImport => (code) {
        return '/{baseSiteId}/sales/production/order/import/from/uniqueCode/$code';
      };

  /// 外发订单列表
  static get outOrderList => '/{baseSiteId}/out/order/search';

  /// 生产工单列表
  static get productionTaskOrderList =>
      '/{baseSiteId}/production/task/order/search';

  static get outProductionTaskOrderList =>
      '/{baseSiteId}/out/order/production/search';

  /// 生产工单详情
  static get productionTaskOrderDetail => (id) {
        return '/{baseSiteId}/production/task/order/$id';
      };

  /// 进度工单列表
  static get progressWorkSheetList => '/{baseSiteId}/sheets/progress/work';

  /// 创建外发订单
  static get createOutOrder => '/{baseSiteId}/out/order/save';
}
