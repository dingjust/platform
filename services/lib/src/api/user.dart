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

  //获取地址列表
  static get addresses => '/{baseSiteId}/b2b/company/addresses';

  //获取地址明细
  static get getAddress => (id) => '/{baseSiteId}/b2b/company/addresses/$id';

  //创建地址
  static get addressCreate => '/{baseSiteId}/b2b/company/addresses';
  //更新地址
  static get addressUpdate => '/{baseSiteId}/b2b/company/addresses';
  //删除地址
  static get addressDelete => (id) => '/{baseSiteId}/b2b/company/addresses/$id';
}
