import 'package:package_info/package_info.dart';
import 'package:services/services.dart';
import 'package:connectivity/connectivity.dart';

class AppBLoC extends BLoCBase {
  //包信息
  PackageInfo packageInfo;

  ///网络连接状态
  ConnectivityResult _connectivityResult;

  // 工厂模式
  factory AppBLoC() => _getInstance();

  static AppBLoC get instance => _getInstance();
  static AppBLoC _instance;

  AppBLoC._internal() {
    // 初始化
    PackageInfo.fromPlatform().then((PackageInfo info) {
      packageInfo = info;
      print(
          'AppName: ${packageInfo.appName} PackageName: ${packageInfo.packageName} Version: ${packageInfo.version} BuildNumber: ${packageInfo.buildNumber}');
    });
  }

  static AppBLoC _getInstance() {
    if (_instance == null) {
      _instance = AppBLoC._internal();
    }
    return _instance;
  }

  ConnectivityResult get getConnectivityResult => _connectivityResult;

  void setConnectivityResult(ConnectivityResult result) {
    _connectivityResult = result;
  }

  @override
  void dispose() {}
}
