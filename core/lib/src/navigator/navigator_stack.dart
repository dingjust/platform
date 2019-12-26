class NavigatorStack {
  // 工厂模式
  factory NavigatorStack() => _getInstance();

  static NavigatorStack get instance => _getInstance();
  static NavigatorStack _instance;

  NavigatorStack._internal() {
    // 初始化
  }

  static NavigatorStack _getInstance() {
    if (_instance == null) {
      _instance = new NavigatorStack._internal();
    }
    return _instance;
  }

  String _currentRouteName;

  String get currentRouteName => _currentRouteName;

  void setCurrentRouteName(String val) {
    _currentRouteName = val;
  }
}
