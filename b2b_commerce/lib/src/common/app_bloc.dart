import 'package:package_info/package_info.dart';
import 'package:services/services.dart';

class AppBLoC extends BLoCBase {
  //
  PackageInfo packageInfo;

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

  @override
  void dispose() {}
}
