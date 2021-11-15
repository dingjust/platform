///微信小程序页面路由
class MiniProgramPageRoutes {
  ///首页
  static get index => 'pages/index/index';

  ///需求详情
  static get requirementDetail => (code) {
        return 'pages/order/requirement/detail/index?code=$code';
      };

  ///渠道码注册
  static get channelCodeRegister => (code) {
        return 'pages/index/index?channelCode=$code';
      };

  ///看款详情
  static get productDetail => (code) {
        return 'pages/dd/detail/index?code=$code';
      };

  ///看款列表
  static get products => 'pages/dd/dd';

  ///工厂详情
  static get factoryDetail => (companyCode) {
        return 'pages/company/factory/profile/index?companyCode=$companyCode';
      };

  ///订单详情
  static get orderDetail => (id) {
        return 'pages/order/external-sale/detail/index?id=$id';
      };
}

///微信小程序URL Scheme
class MiniProgramURLScheme {
  ///看款列表
  static get products => 'weixin://dl/business/?t=FeOlCjCrojl';
}
