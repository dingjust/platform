/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        if (type != 'BRAND') {
          return '/{baseSiteId}/factory/register';
        }
        return '/{baseSiteId}/brand/register';
      };

  /// 用户信息
  static get userInfo => '/{baseSiteId}/b2b/users/profile';
}
