class NavigatorStack {
  // 工厂模式
  factory NavigatorStack() => _getInstance()!;

  static NavigatorStack? get instance => _getInstance();
  static NavigatorStack? _instance;

  NavigatorStack._internal() {
    // 初始化
  }

  static NavigatorStack? _getInstance() {
    if (_instance == null) {
      _instance = new NavigatorStack._internal();
    }
    return _instance;
  }

  String? _currentRouteName;

  String? get currentRouteName => _currentRouteName;

  ///缓存路由
  CacheRouteInfo? _cacheRouteInfo;

  CacheRouteInfo? get cacheRouteInfo => _cacheRouteInfo;

  void setCurrentRouteName(String val) {
    _currentRouteName = val;
  }

  void setCacheRoute(CacheRouteInfo val) {
    _cacheRouteInfo = val;
  }

  void clearCacheRoute() {
    _cacheRouteInfo = null;
  }
}

///缓存路由信息
class CacheRouteInfo {
  final String? route;

  final Object? arguments;

  CacheRouteInfo({this.route, this.arguments});
}
