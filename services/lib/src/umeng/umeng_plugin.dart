import 'package:core/core.dart';
import 'package:services/src/user/bloc/user_bloc.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

///友盟移动统计插件
class UmengPlugin {
  ///友盟初始化
  static Future<dynamic> initCommon(
      String androidAppkey, String iosAppkey, String channel) async {
    final dynamic result =
        UmengCommonSdk.initCommon(androidAppkey, iosAppkey, channel);
    return result;
  }

  ///事件
  static void onEvent(String event,
      {Map<String, dynamic> properties = const {}}) {
    // 基础参数
    String userType = UserTypeLocalizedMap[UserBLoC.instance.currentUser.type];
    UmengCommonSdk.onEvent(event, {'userType': userType, ...properties});
  }

  /// 设置用户账号
  static void onProfileSignIn(String userID) {
    UmengCommonSdk.onProfileSignIn(userID);
  }

  /// 取消用户账号
  static void onProfileSignOff() {
    UmengCommonSdk.onProfileSignOff();
  }

  /// 如果需要使用页面统计，则先打开该设置
  static void setPageCollectionModeManual() {
    UmengCommonSdk.setPageCollectionModeManual();
  }

  /// 进入页面统计
  static void onPageStart(String viewName) {
    UmengCommonSdk.onPageStart(viewName);
  }

  /// 离开页面统计
  static void onPageEnd(String viewName) {
    UmengCommonSdk.onPageEnd(viewName);
  }

  /// 如果不需要上述页面统计，在完成后可关闭该设置；如果没有用该功能可忽略；
  static void setPageCollectionModeAuto() {
    UmengCommonSdk.setPageCollectionModeAuto();
  }

  /// 错误发送
  static void reportError(String error) {
    UmengCommonSdk.reportError(error);
  }
}
