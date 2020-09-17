///授权相关API
class AuthApis {
  ///微信Code获取授权码
  static get authCodeByWechatCode => (String code) {
        return '/{baseSiteId}/wechat/open/access_login/nbyjy/B2B/$code';
      };
}
