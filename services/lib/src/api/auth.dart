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

  ///钉钉Code获取授权码
  static get authCodeByDingTalk => (String code) {
        return '/{baseSiteId}/dingtalk/auth/access_login/nbyjy/B2B/$code';
      };

  ///钉钉授权绑定账号
  static get dingTalkAuthBinding => (String code) {
        return '/{baseSiteId}/dingtalk/auth/access_bind/$code';
      };

  ///解除钉钉绑定账号
  static get dingTalkAuthUnBinding =>
      '/{baseSiteId}/dingtalk/auth/access_unbind';
}
