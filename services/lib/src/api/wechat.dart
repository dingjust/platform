///微信
class WechatApis {
  // === 支付 ===
  /// 预付码
  static get wechatPrepay => (code) {
        return '/b2b/checkout/multi/wechat/prepay/$code';
      };

  /// 打样单----- 确认支付
  static get proofingPaidConfirm => (code) {
        return '/b2b/orders/proofing/$code/paid';
      };

  /// 生产单-定金 ----- 确认支付
  static get purchaseDepositPaidConfirm => (code) {
        return '/b2b/orders/purchase/$code/paid/deposit';
      };

  /// 生产单-尾款 ----- 确认支付
  static get purchaseBalancePaidConfirm => (code) {
        return '/b2b/orders/purchase/$code/paid/balance';
      };
}
