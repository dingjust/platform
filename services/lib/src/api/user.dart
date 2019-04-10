/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        return '/b2b/companies/register/$type';
      };

  //发送短信验证码
  static get sendCaptcha => (phone) => '/b2b/sms/captcha/$phone';

  //验证验证码是否正确
  static get validateCaptcha => '/b2b/sms/validate';

  /// 用户信息
  static get userInfo => (uid) => '/b2b/users/' + uid + '/profile';
  //获取地址列表
  static get addresses => '/b2b/company/addresses';

  //获取地址明细
  static get getAddress => (id) => '/b2b/company/addresses/$id';

  //创建地址
  static get addressCreate => '/b2b/company/addresses';
  //更新地址
  static get addressUpdate => (id) => '/b2b/company/addresses/$id';
  //删除地址
  static get addressDelete => (id) => '/b2b/company/addresses/$id';

  //产业集群
  static get getIndustrialClusterFromLabels =>
      '/b2b/industrialClusters/labels';

  //标签列表
  static get labels => '/b2b/labels/all';

  ///工作报表
  static get reports => '/b2b/company/reports';

  ///全部需求/推荐需求报表
  static get requirementReports => '/b2b/company/reports/requirement';

  ///手机号是否注册
  static get phoneExists => (code) {
        return '/b2b/companies/register/$code';
      };
}
