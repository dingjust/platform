/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        return '/{baseSiteId}/companies/register/$type';
      };

  //发送短信验证码
  static get sendCaptcha => (phone) => '/{baseSiteId}/sms/captcha/$phone';

  //验证验证码是否正确
  static get validateCaptcha => '/{baseSiteId}/sms/validate';

  /// 用户信息
  static get userInfo => (uid) => '/{baseSiteId}/users/' + uid + '/profile';
  //获取地址列表
  static get addresses => '/{baseSiteId}/company/addresses';

  //获取地址明细
  static get getAddress => (id) => '/{baseSiteId}/company/addresses/$id';

  //创建地址
  static get addressCreate => '/{baseSiteId}/company/addresses';
  //更新地址
  static get addressUpdate => (id) => '/{baseSiteId}/company/addresses/$id';
  //删除地址
  static get addressDelete => (id) => '/{baseSiteId}/company/addresses/$id';

  //产业集群
  static get getIndustrialClusterFromLabels =>
      '/{baseSiteId}/industrialClusters/labels';

  //标签列表
  static get labels => '/{baseSiteId}/labels/all';

  ///工作报表
  static get reports => '/{baseSiteId}/company/reports';

  ///全部需求/推荐需求报表
  static get requirementReports => '/{baseSiteId}/company/reports/requirement';

  ///手机号是否注册
  static get phoneExists => (code) {
        return '/{baseSiteId}/companies/register/$code';
      };
}
