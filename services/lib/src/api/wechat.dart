///微信
class WechatApis {
  // === 支付 ===
  /// 预付码
  static get wechatPrepay => (code) {
        return '/{baseSiteId}/checkout/multi/wechat/prepay/$code';
      };

  /// 打样单----- 确认支付
  static get proofingPaidConfirm => (code) {
        return '/{baseSiteId}/b2b/orders/proofing/$code/paid';
      };
}
