import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  ///第一次启动记录时间
  static const String key = 'firstStartUpTime';

  ///用户同意《隐私政策》时间
  static const String key2 = 'privacyAgreeTime';

  String firstStartUpTime;

  String privacyAgreeTime;

  ///本地记录检测
  void checkFirstStartUp(BuildContext context) async {
    if (firstStartUpTime == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String val = sharedPreferences.getString(key);
      if (val != null && val != '') {
        firstStartUpTime = val;

        ///用户是否已同意
        String val2 = sharedPreferences.getString(key2);
        if (val2 == null || val2 == '') {
          Navigator.of(context).pushNamed(AppRoutes.ROUTE_PRIVACY_GUIDE);
        } else {
          //已同意直接初始化
          //执行友盟初始化
          UmengPlugin.initCommon();
          print('[友盟初始化]');
        }
      } else {
        //第一次启动
        firstStartUpTime = DateTime.now().toIso8601String();
        sharedPreferences.setString(key, firstStartUpTime).then((value) {
          Navigator.of(context).pushNamed(AppRoutes.ROUTE_PRIVACY_GUIDE);
        });
      }
    }
  }

  Future<bool> setPrivacyAgreeTime() async {
    String val = DateTime.now().toIso8601String();
    privacyAgreeTime = val;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key2, val);
  }
}
