/// 产能API
class CapacityApis {
  /// 创建工厂产能API
  static get save => '/{baseSiteId}/factory/capacity/save';

  ///当前公司产能列表
  static get list => '/{baseSiteId}/factory/capacity/list';

  ///品牌端查询
  static get search => '/{baseSiteId}/factory/capacity/search';

  ///切换状态
  static get switchStatus =>
          (code) {
        return '/{baseSiteId}/factory/capacity/switch/status/$code';
      };

  ///刷新
  static get refresh =>
          (code) {
        return '/{baseSiteId}/factory/capacity/refresh/$code';
      };
}
