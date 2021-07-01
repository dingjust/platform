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
}
