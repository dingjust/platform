/// 应用API
abstract class UserApis {
  /// 注册 POST
  static get register => (type) {
        return '/{baseSiteId}/companies/register/$type';
      };

  //发送短信验证码
  static get sendCaptcha => (phone) => '/{baseSiteId}/sms/captcha/$phone';
  //发送登录用的验证码
  static get sendCaptchaForLogin =>
          (phone) => '/{baseSiteId}/sms/captcha/asm/B2B/$phone';

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

  ///未登录时全部需求报表
  static get offlineRequirementReports =>
      '/{baseSiteId}/orders/requirement/countByStatuses';

  ///手机号是否注册
  static get phoneExists => (code) {
        return '/{baseSiteId}/companies/register/$code';
      };

  //获取发票抬头列表
  static get invoiceTitles => '/{baseSiteId}/company/invoice/title';
  //创建发票抬头
  static get invoiceTitleCreate => '/{baseSiteId}/company/invoice/title';
  //更新/删除发票抬头(详情)
  static get invoiceTitleFromId =>
          (id) => '/{baseSiteId}/company/invoice/title/$id';

  //获取所有角色
  static get roles => '/{baseSiteId}/roles';

  //获取员工列表
  static get employees => '/{baseSiteId}/b2bCustomers';

  //创建员工
  static get employeeCreate => '/{baseSiteId}/b2bCustomers/create';

  //更新/删除员工(详情)
  static get employeeFromId => (uid) => '/{baseSiteId}/b2bCustomers/$uid';

  ///短信验证重置密码
  static get resetPassword => (id) {
        return '/{baseSiteId}/users/anonymous/resetPasswordByCaptcha/$id';
      };

  ///获取钱包
  static get getCompanyWallet => '/{baseSiteId}/companyWallet';

  ///获取流水列表
  static get getAmountFlows => '/{baseSiteId}/amountFlow';

  ///获取流水明细
  static get getAmountFlow => (id) => '/{baseSiteId}/amountFlow/$id';

  ///申请提现
  static get cashOut => (amount) => '/{baseSiteId}/amountFlow/cashOut/$amount';

  ///提现取消
  static get cashOutCanceled =>
          (id) => '/{baseSiteId}/amountFlow/cashOutCanceled/$id';

  ///获取账单列表
  static get bills => '/{baseSiteId}/bill';

  ///获取账单详情
  static get billDetail => (code) => '/{baseSiteId}/bill/$code';

  ///查询/绑定银行卡
  static get bankCard => '/{baseSiteId}/bankCard';
}
