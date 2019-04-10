/// 订单API
class OrderApis {
  // ========需求=========

  /// 根据条件获取需求订单列表 POST
  static get requirementOrders => '/b2b/orders/requirement';

  /// 根据条件获取需求订单列表 POST
  static get requirementOrdersAll => '/b2b/orders/requirement/all';

  //全部需求列表 POST
  static get allOrdersForFactory => '/b2b/orders/requirement/factory/all';

  //推荐需求列表 POST
  static get allRecommendedOrders => '/b2b/orders/requirement/factory/recommended';

  /// 急速发布需求/发布需求 POST
  static get requirementOrderNew => '/b2b/orders/requirement/new';

  /// 重新发布需求，带出已有需求订单中的需求信息，??是否需要关联原始需求 POST
  static get requirementOrderCopyFrom => (code) {
        return '/b2b/orders/requirement/$code/new';
      };

  /// 根据订单编号获取明细 GET
  static get requirementOrderDetail => (code) {
        return '/b2b/orders/requirement/$code';
      };

  /// 根据订单编号获取报价单列表 GET
  static get requirementOrderQuotes => (code) {
        return '/b2b/orders/requirement/$code/quotes';
      };

  //获取所有物流公司名称和Code GET
  static get getCarriersAll => '/b2b/carriers';

  /// 根据条件获取采购订单列表 POST
  static get purchaseOrders => '/b2b/orders/purchase';

  /// 根据采购订单编号获取明细 GET
  static get purchaseOrderDetail => (code) {
        return '/b2b/orders/purchase/$code';
      };

  //根据唯一码获取订单明细
  static get getDetailsForUniqueCode => (code) {
        return '/b2b/orders/purchase/unique/$code';
      };

  //创建线下采购订单 POST
  static get purchaseOfflineOrders =>
      '/b2b/orders/purchase/create';

  //创建线上生产订单
  static get purchaseOnlineOrders => (quote) {
        return '/b2b/orders/purchase/create/$quote';
      };

  //修改生产进度时间或数量
  static get productionProgressUpload => (code, id) {
        return '/b2b/orders/purchase/$code/progress/$id';
      };

  //修改生产订单尾款金额
  static get purchaseOrderBalanceUpdate => (code) {
        return '/b2b/orders/purchase/$code/balance';
      };

  //修改生产订单定金和单价
  static get purchaseOrderDepositUpdate => (code) {
        return '/b2b/orders/purchase/$code/deposit';
      };

  //取消生产订单
  static get purchaseOrderCancelling => (code) {
        return '/b2b/orders/purchase/$code/cancelling';
      };

  //确认发货
  static get purchaseOrderDelivering => (code) {
        return '/b2b/orders/purchase/$code/delivering';
      };

  //确认收货
  static get purchaseOrderShipped => (code) {
        return '/b2b/orders/purchase/$code/shipped';
      };

  //生成唯一码
  static get generateUniqueCode => (code) {
        return '/b2b/orders/purchase/$code/unique';
      };

  //关联唯一码
  static get linkUniqueCode => (code) {
        return '/b2b/orders/purchase/link/$code';
      };

  //确认生产
  static get confirmProduction => (code) {
        return '/b2b/orders/purchase/$code/production';
      };

  //品牌更新地址
  static get updateAddress => (code) {
        return '/b2b/orders/purchase/$code/deliveryAddress';
      };

  //品牌更新地址（打样订单）
  static get updateProofAddress => (code) {
    return '/b2b/orders/proofing/$code/deliveryAddress';
  };

  /// 根据条件获取报价单列表 POST
  static get quotes => '/b2b/orders/quote';

  /// 根据报价单编号获取明细 GET
  static get quoteDetail => (code) {
        return '/b2b/orders/quote/$code';
      };

  /// 确认报价 PUT
  static get quoteApprove => (code) {
        return '/b2b/orders/quote/$code/approve';
      };

  /// 拒绝报价 PUT
  static get quoteReject => (code) {
        return '/b2b/orders/quote/$code/reject';
      };

  ///创建报价
  static get quoteCreate => '/b2b/orders/quote/create';

  ///更新报价
  static get quoteUpdate => (code) {
        return '/b2b/orders/quote/$code';
      };

  ///创建打样单
  static get proofingCreate => (code) {
        return '/b2b/orders/proofing/create/$code';
      };

  /// 根据条件获取打样单列表 POST
  static get proofing => '/b2b/orders/proofing';

  /// 根据条件获取打样单明细
  static get proofingDetail => (code) {
        return '/b2b/orders/proofing/$code';
      };

  /// 取消打样单
  static get proofingCancelling => (code) {
        return '/b2b/orders/proofing/$code/cancelling';
      };

  /// 更新打样单
  static get proofingUpdate => (code) {
        return '/b2b/orders/proofing/$code/balance';
      };

  //确认发货
  static get proofingDelivering => (code) {
        return '/b2b/orders/proofing/$code/delivering';
      };

  //确认收货
  static get shipped => (code) {
    return '/b2b/orders/proofing/$code/shipped';
  };

  /// 更新需求信息
  static get requirementUpdate => (code) {
        return '/b2b/orders/requirement/$code';
      };

  //邀请工厂（推荐需求）
  static get doRecommendation => (code,uid) {
    return '/b2b/orders/requirement/$code/factory/$uid/recommend';
  };
}
