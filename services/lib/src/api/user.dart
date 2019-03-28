/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        return '/{baseSiteId}/b2b/companies/register/$type';
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
  static get addressUpdate => (id) => '/{baseSiteId}/b2b/company/addresses/$id';
  //删除地址
  static get addressDelete => (id) => '/{baseSiteId}/b2b/company/addresses/$id';

  //产业集群
  static get getIndustrialClusterFromLabels =>
      '/{baseSiteId}/b2b/industrialClusters/labels';

  //标签列表
  static get labels => '/{baseSiteId}/labels/all';

  ///工作报表
  static get reports => '/{baseSiteId}/b2b/company/reports';
}
