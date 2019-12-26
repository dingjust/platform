///转包相关接口
class SubContractApis {
  /// 转包列表
  static get subcontracts => '/{baseSiteId}/subcontract';
  /// 全部工厂转包列表
  static get subcontractsByAllFactory => '/{baseSiteId}/subcontract/factory/all';

  /// 转包详情
  static get subcontractDetail => (code) {
        return '/{baseSiteId}/subcontract/$code';
      };

  /// 关闭转包
  static get subcontractCancelled=> (code) {
    return '/{baseSiteId}/subcontract/cancelled/$code';
  };

  /// 创建转包
  static get subcontractsCreate => '/{baseSiteId}/subcontract/new';

  /// 更新转包
  static get subcontractsUpdate => '/{baseSiteId}/subcontract/update';

}
