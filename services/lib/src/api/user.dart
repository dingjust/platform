/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        if (type != 'BRAND') {
          return '/{baseSiteId}/b2b/factory/register';
        }

        return '/{baseSiteId}/b2b/brand/register';
      };

  /// 用户信息
  static get userInfo => '/{baseSiteId}/b2b/users/profile';
}
