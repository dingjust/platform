import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

///网络State
class NetState with ChangeNotifier {
  // 工厂模式
  factory NetState() => _getInstance();

  static NetState get instance => _getInstance();
  static NetState _instance;

  NetState._internal() {
    // 初始化
  }

  static NetState _getInstance() {
    if (_instance == null) {
      _instance = NetState._internal();
    }
    return _instance;
  }

  ///网络链接状态
  ConnectivityResult _connectivityResult;

  ConnectivityResult get connectivityResult => _connectivityResult;

  void setConnectivityResult(ConnectivityResult result) {
    if (_connectivityResult != result) {
      _connectivityResult = result;

      ///通知刷新
      notifyListeners();
    }
  }
}
