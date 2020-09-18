///授权相关API
class AuthApis {
  ///微信Code获取授权码
  static get authCodeByWechatCode => (String code) {
        return '/{baseSiteId}/wechat/open/access_login/nbyjy/B2B/$code';
      };

  ///微信授权绑定账号
  static get wechatAuthBinding => (String code) {
        return '/{baseSiteId}/wechat/open/access_bind/$code';
      };

  ///解除微信绑定账号
  static get wechatAuthUnBinding => '/{baseSiteId}/wechat/open/access_unbind';
}
