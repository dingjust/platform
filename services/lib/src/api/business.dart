/// 商务API
class BusinessApis {
  /// 代运营服务申请
  static get operationAgentServiceApply =>
      '/{baseSiteId}/agentOperation/submit';

  /// 代运营服务申请
  static get operationAgentInfo => '/{baseSiteId}/agentOperation/getInfo';

  /// 托管服务申请
  static get delegationApply => '/{baseSiteId}/trusteeship/order/submit';
}
