/// 订单API
class OrderApis {
  // ========需求=========

  /// 根据条件获取需求订单列表 POST
  static get requirementOrders => '/{baseSiteId}/orders/requirement';

  /// 传入经纬度需求订单列表 POST
  static get requirementOrdersMap => '/{baseSiteId}/orders/requirement/map';

  ///关闭需求订单
  static get requirementOrderCancle => (code) {
        return '/{baseSiteId}/orders/requirement/cancelled/$code';
      };

  /// 根据条件获取需求订单列表 POST
  static get requirementOrdersAll => '/{baseSiteId}/orders/requirement/all';

  //全部需求列表 POST
  static get allOrdersForFactory =>
      '/{baseSiteId}/orders/requirement/factory/all';

  //推荐需求列表 POST
  static get allRecommendedOrders =>
      '/{baseSiteId}/orders/requirement/factory/recommended';

  /// 急速发布需求/发布需求 POST
  static get requirementOrderNew => '/{baseSiteId}/orders/requirement/new';

  /// 重新发布需求，带出已有需求订单中的需求信息，??是否需要关联原始需求 POST
  static get requirementOrderCopyFrom => (code) {
        return '/{baseSiteId}/orders/requirement/$code/new';
      };

  /// 根据订单编号获取明细 GET
  static get requirementOrderDetail => (code) {
        return '/{baseSiteId}/orders/requirement/$code';
      };

  /// 根据订单编号获取报价单列表 GET
  static get requirementOrderQuotes => (code) {
        return '/{baseSiteId}/orders/requirement/$code/quotes';
      };

  //获取所有物流公司名称和Code GET
  static get getCarriersAll => '/{baseSiteId}/carriers';

  /// 根据条件获取采购订单列表 POST
  static get purchaseOrders => '/{baseSiteId}/orders/purchase';

  /// 根据采购订单编号获取明细 GET
  static get purchaseOrderDetail => (code) {
        return '/{baseSiteId}/orders/purchase/$code';
      };

  //根据唯一码获取订单明细
  static get getDetailsForUniqueCode => (code) {
        return '/{baseSiteId}/orders/purchase/unique/$code';
      };

  //创建线下采购订单 POST
  static get purchaseOfflineOrders => '/{baseSiteId}/orders/purchase/create';

  ///创建线下订单v2
  static get createOfflinePurchaseOrder =>
      '/b2b/orders/purchase/createByOffline';

  //看款下单创建采购订单 POST
  static get purchaseCreateByProduct =>
          (productBelongTo) =>
      '/{baseSiteId}/orders/purchase/createByProduct/$productBelongTo';

  //创建线上生产订单
  static get purchaseOnlineOrders => (quote) {
        return '/{baseSiteId}/orders/purchase/create/$quote';
      };

  //修改生产进度时间或数量
  static get productionProgressUpload => (code, id) {
        return '/{baseSiteId}/orders/purchase/$code/progress/$id';
      };

  //批量修改生产进度预计完成时间
  static get progressEstimatedDateUploads =>
          (code, id) {
        return '/{baseSiteId}/orders/purchase/$code/progresses';
      };

  //修改生产订单尾款金额
  static get purchaseOrderBalanceUpdate => (code) {
        return '/{baseSiteId}/orders/purchase/$code/balance';
      };

  //修改生产订单尾款扣款金额
  static get purchaseOrderDeductionAmountUpdate => (code) {
        return '/{baseSiteId}/orders/purchase/$code//update/deductionAmount';
      };

  //修改生产订单定金和单价
  static get purchaseOrderDepositUpdate => (code) {
        return '/{baseSiteId}/orders/purchase/$code/deposit';
      };

  //取消生产订单
  static get purchaseOrderCancelling => (code) {
        return '/{baseSiteId}/orders/purchase/$code/cancelling';
      };

  //确认发货
  static get purchaseOrderDelivering => (code) {
        return '/{baseSiteId}/orders/purchase/$code/delivering';
      };

  //确认收货
  static get purchaseOrderShipped => (code) {
        return '/{baseSiteId}/orders/purchase/$code/shipped';
      };

  //生成唯一码
  static get generateUniqueCode => (code) {
        return '/{baseSiteId}/orders/purchase/$code/unique';
      };

  //关联唯一码
  static get linkUniqueCode => (code) {
        return '/{baseSiteId}/orders/purchase/link/$code';
      };

  //确认生产
  static get confirmProduction => (code) {
        return '/{baseSiteId}/orders/purchase/$code/production';
      };

  //品牌更新地址
  static get updateAddress => (code) {
        return '/{baseSiteId}/orders/purchase/$code/deliveryAddress';
      };

  //品牌更新地址（打样订单）
  static get updateProofAddress =>
          (code) {
        return '/{baseSiteId}/orders/proofing/$code/deliveryAddress';
      };

  /// 根据条件获取报价单列表 POST
  static get quotes => '/{baseSiteId}/orders/quote';

  /// 根据报价单编号获取明细 GET
  static get quoteDetail => (code) {
        return '/{baseSiteId}/orders/quote/$code';
      };

  /// 确认报价 PUT
  static get quoteApprove => (code) {
        return '/{baseSiteId}/orders/quote/$code/approve';
      };

  /// 拒绝报价 PUT
  static get quoteReject => (code) {
        return '/{baseSiteId}/orders/quote/$code/reject';
      };

  ///创建报价
  static get quoteCreate => '/{baseSiteId}/orders/quote/create';

  ///更新报价
  static get quoteUpdate => (code) {
        return '/{baseSiteId}/orders/quote/$code';
      };

  ///创建打样单
  static get proofingCreate => (code) {
        return '/{baseSiteId}/orders/proofing/create/$code';
      };

  ///看款创建打样单
  static get proofingCreateByProduct =>
          (productBelongTo) {
        return '/{baseSiteId}/orders/proofing/createByProduct/$productBelongTo';
      };

  /// 根据条件获取打样单列表 POST
  static get proofing => '/{baseSiteId}/orders/proofing';

  /// 根据条件获取打样单明细
  static get proofingDetail => (code) {
        return '/{baseSiteId}/orders/proofing/$code';
      };

  /// 取消打样单
  static get proofingCancelling => (code) {
        return '/{baseSiteId}/orders/proofing/$code/cancelling';
      };

  /// 更新打样单
  static get proofingUpdate => (code) {
        return '/{baseSiteId}/orders/proofing/$code/balance';
      };

  //确认发货
  static get proofingDelivering => (code) {
        return '/{baseSiteId}/orders/proofing/$code/delivering';
      };

  //确认收货
  static get shipped =>
          (code) {
        return '/{baseSiteId}/orders/proofing/$code/shipped';
      };

  /// 更新需求信息
  static get requirementUpdate => (code) {
        return '/{baseSiteId}/orders/requirement/$code';
      };

  //邀请工厂（推荐需求）
  static get doRecommendation =>
          (code, uid) {
        return '/{baseSiteId}/orders/requirement/$code/factory/$uid/recommend';
      };

  //邀请工厂（推荐多个需求给多个工厂）
  static get doRecommendations => () {
        return '/{baseSiteId}/orders/requirement/factory/recommend';
      };

  //确认打样订单
  static get proofingConfirm =>
          (code) {
        return '/{baseSiteId}/orders/proofing/$code/paid';
      };

  // ========生产单=========

  ///生产单拒单
  static get cancellingOfPurchaseOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/cancelling';
      };

  ///确认线下生产订单
  static get confirmProductionByOffline =>
          (code) {
        return '/b2b/orders/purchase/$code/confirmProductionByOffline';
      };

  ///创建部分发货单
  static get createShippingOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/createShippingOrder';
      };

  ///创建全部发货单
  static get confirmShipping =>
          (code) {
        return '/b2b/orders/purchase/$code/confirmShipping';
      };

  ///创建收货单
  static get createDeliveryOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/createDeliveryOrder';
      };

  ///创建并提交收货单
  static get createAndCommitDeliveryOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/createAndCommitDeliveryOrder';
      };

  ///更新并提交收货单
  static get updateAndCommitDeliveryOrder =>
          () {
        return '/b2b/orders/purchase/updateAndCommitDeliveryOrder';
      };

  ///提交收货单
  static get commitDeliveryOrder =>
          () {
        return '/b2b/orders/purchase/commitDeliveryOrder';
      };

  ///保存收货单
  static get updateDeliveryOrder =>
          () {
        return '/b2b/orders/purchase/updateDeliveryOrder';
      };

  ///撤回收货单
  static get withdrawDeliveryOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/recallDelivery';
      };

  ///确认收货单
  static get confirmDeliveryOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/confirmDelivery';
      };

  ///拒绝收货单
  static get rejectDeliveryOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/rejectDelivery';
      };

  ///创建对账单
  static get createReconciliationOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/createReconciliationOrder';
      };

  ///创建并提交对账单
  static get createAndCommitReconciliationOrder =>
          (code) {
        return '/b2b/orders/purchase/$code/createAndCommitReconciliationOrder';
      };

  ///更新对账单
  static get updateReconciliationOrder =>
          () {
        return '/b2b/orders/purchase/updateReconciliationOrder';
      };

  ///更新并提交对账单
  static get updateAndCommitReconciliationOrder =>
          () {
        return '/b2b/orders/purchase/updateAndCommitReconciliationOrder';
      };

  ///撤回对账单
  static get recallReconciliationOrder =>
          () {
        return '/b2b/orders/purchase/recallReconciliationOrder';
      };

  ///确认对账单
  static get confirmReconciliation =>
          (code) {
        return '/b2b/orders/purchase/$code/confirmReconciliation';
      };

  ///拒绝对账单
  static get rejectReconciliation =>
          (code) {
        return '/b2b/orders/purchase/$code/rejectReconciliation';
      };

  ///创建生产进度单据
  static get createProductionProgressOrder =>
          (id) {
        return '/b2b/orders/purchase/progress/$id/order';
      };

  ///作废生产进度单据
  static get deleteProductionProgressOrder =>
          (id, orderId) {
        return '/b2b/orders/purchase/progress/$id/order/$orderId';
      };

  ///修改生产进度单据
  static get updateProductionProgressOrder =>
          (id, orderId) {
        return '/b2b/orders/purchase/progress/$id/order/$orderId';
      };

  ///看款下单创建销售订单 POST
  static get salesCreateByProduct => '/{baseSiteId}/b2b/orders/sales/create';

  ///看款下单创建销售订单 POST
  static get salesOrderList => '/{baseSiteId}/b2b/orders/sales';

  ///销售订单详情
  static get salesOrderDetails =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/$code';
      };

  ///销售订单发货
  static get salesOrderDelivery =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/update/consignment/$code';
      };

  ///销售订单确认收货
  static get salesOrderConfirmReceived =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/$code/confirmReceived';
      };

  ///销售订单关闭订单
  static get salesOrderCancel =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/$code/cancel/order';
      };

  ///销售订单申请退款
  static get salesOrderRefundApply => '/{baseSiteId}/sales/order/refund/apply';

  ///销售订单退款信息
  static get salesOrderRefundInfo =>
          (code) {
        return '/{baseSiteId}/sales/order/refund/apply/$code';
      };

  ///销售订单退款处理
  static get salesOrderRefundAudit =>
      '/{baseSiteId}/sales/order/refund/audit/apply';

  ///销售订单退款处理
  static get salesOrderRefundCancel =>
          (code) {
        return '/{baseSiteId}/sales/order/refund/apply/cancel/$code';
      };

  ///销售订单提醒发货
  static get salesOrderRemind =>
          (code) {
        return '/{baseSiteId}/b2b/orders/sales/$code/reminder/delivery';
      };
}
