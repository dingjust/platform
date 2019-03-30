///微信
class WechatApis {
  // === 支付 ===
  /// 预付码
  static get wechatPrepay => (code) {
        return '/{baseSiteId}/checkout/multi/wechat/prepay/$code';
      };
}
