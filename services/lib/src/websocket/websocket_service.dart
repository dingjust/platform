class WebSocketService {
  // 工厂模式
  factory WebSocketService() => _getInstance();

  static WebSocketService get instance => _getInstance();
  static WebSocketService _instance;

  WebSocketService._internal() {
    // 初始化

  }

  static WebSocketService _getInstance() {
    if (_instance == null) {
      _instance = new WebSocketService._internal();
    }
    return _instance;
  }
}
