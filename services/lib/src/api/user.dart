import 'package:core/core.dart';

/// 应用API
abstract class UserApis {
  static const String _clientId = GlobalConfigs.B2B_CLIENT_ID;

  /// 注册 POST
  static get register => (type) {
        return '/{baseSiteId}/companies/register/$type';
      };

  //发送短信验证码
  static get sendCaptcha => (phone) => '/{baseSiteId}/sms/captcha/$phone';

  //发送登录用的验证码
  static get sendCaptchaForLogin =>
      (phone) => '/{baseSiteId}/sms/captcha/$_clientId/B2B/$phone';

  //验证验证码是否正确
  static get validateCaptcha => '/{baseSiteId}/sms/validate';

  /// 用户信息
  static get userInfo => '/{baseSiteId}/b2bCustomers/profile';

  /// 更新用户信息
  static get updateUserInfo =>
      (uid) => '/{baseSiteId}/b2bCustomers/' + uid + '/updateUserInfo';

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
  static get resetPassword =>
          (id) {
        return '/{baseSiteId}/users/anonymous/resetPasswordByCaptcha/$id';
      };

  ///重置密码
  static get resetPasswordByPassword =>
          (id) {
        return '/{baseSiteId}/users/$id/password';
      };

  ///获取钱包
  static get getCompanyWallet => '/{baseSiteId}/companyWallet';

  ///获取流水列表
  static get getAmountFlows => '/{baseSiteId}/amountFlow';

  ///获取流水明细
  static get getAmountFlow => (id) => '/{baseSiteId}/amountFlow/$id';

  ///申请提现
  static get cashOut => '/{baseSiteId}/companyWallet/cashOut';

  ///提现取消
  static get cashOutCanceled =>
          (id) => '/{baseSiteId}/companyWallet/cashOutCanceled/$id';

  ///获取账单列表
  static get bills => '/{baseSiteId}/bill';

  ///获取账单详情
  static get billDetail => (code) => '/{baseSiteId}/bill/$code';

  ///查询/绑定银行卡
  static get bankCard => '/{baseSiteId}/bankCard';

  ///解绑银行卡
  static get unbindBankCard => (id) => '/{baseSiteId}/bankCard/$id';

  ///合同管理列表
  static get contractList => '/{baseSiteId}/user/agreement/list';

  //获取pdf文件
  static get downContract =>
          (code) {
        return '/{baseSiteId}/user/agreement/get/download/token/' + code;
      };

  //APP下载PDF
  static get downContractInApp =>
          (code) {
        return '/{baseSiteId}/user/agreement/download/in/app/' + code;
      };

  //获取合同MediaModel
  static get getContractPdfMedia =>
          (code) {
        return '/{baseSiteId}/user/agreement/preview/' + code;
      };

  ///用户个人认证
  static get personalCertification =>
      '/{baseSiteId}/fdd/api/get/personal/verify/url';

  ///企业认证
  static get enterpriseCertification =>
      '/{baseSiteId}/fdd/api/get/enterprise/verify/url';

  ///个体工商户
  static get individualBusiness =>
          (verifyType, companyType) {
        return '/{baseSiteId}/fdd/api/get/enterprise/verify/url?verifyType=$verifyType&companyType=$companyType';
      };

  ///合同模板列表
  static get tempList => '/{baseSiteId}/user/agreement/temp/list';

  ///印章管理列表
  static get sealList => '/{baseSiteId}/user/seal/list';

  ///创建合同
  static get saveContract => '/{baseSiteId}/user/agreement/save';

  ///开启合同
  static get flowContract =>
          (code, sealCode) {
        return '/{baseSiteId}/user/agreement/start/flow/$code?sealCode=$sealCode';
      };

  //获取合同数量
  static get getContractCount => '/{baseSiteId}/user/agreement/count';

  ///查看合同
  static get getContract =>
          (code) {
        return '/{baseSiteId}/user/agreement/get/$code';
      };

  //个人认证
  static get personalAuthentication =>
      '/{baseSiteId}/fdd/api/save/personal/verify/data';

  //企业认证
  static get enterpriseAuthentication =>
      '/{baseSiteId}/fdd/api/save/enterprise/verify/data';

  //获取认证状态
  static get getAuthenticationState => '/{baseSiteId}/cert/state';

  //获取个人认证信息
  static get getAuthenticationInfo => '/{baseSiteId}/cert/personal/cert/info';

  //获取企业认证信息
  static get getAuthenticationEnterprise =>
      '/{baseSiteId}/cert/enterprise/cert/info';

  ///合作商列表
  static get cooperators => '/{baseSiteId}/cooperator';

  /// 合作商详情
  static get cooperatorDetail =>
          (id) {
        return '/{baseSiteId}/cooperator/$id';
      };

  /// 添加合作商
  static get appendCooperator => '/{baseSiteId}/cooperator/create';

  /// 删除合作商
  static get deleteCooperator =>
          (id) {
        return '/{baseSiteId}/cooperator/delete/$id';
      };

  /// 根据keyword查询全公司列表
  static get companies => '/{baseSiteId}/companies/findBrandAndFactory';

  ///公司账务列表
  static get payplans => '/{baseSiteId}/payPlan';

  ///撤销合同
  static get revokeContract =>
          (code) {
        return '/{baseSiteId}/user/agreement/revoke/$code';
      };

  ///拒签合同
  static get rejectContract =>
          (code) {
        return '/{baseSiteId}/user/agreement/reject/sign/$code';
      };

  ///合同订单验证
  static get contractOrdersValidate =>
      '/{baseSiteId}/user/agreement/order/validate';

  /// 用户权限列表
  static get authorizations =>
          (id) {
        return '/{baseSiteId}/b2bCustomers/role/$id';
      };

  ///公司员工(B2BCustomerExt)列表
  static get b2bCustomer => '/{baseSiteId}/b2bCustomers';

  ///部门列表
  static get b2bDepts => '/{baseSiteId}/dept/tree/list';

  ///创建印章
  static get sealSave => '/{baseSiteId}/user/seal/save';
}
