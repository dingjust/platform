import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  static const String key = 'notFirstStartUp';

  ///非第一次启动
  bool notFirstStartUp;

  ///检测是否第一次启动
  void checkFirstStartUp(BuildContext context) async {
    if (notFirstStartUp == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String val = sharedPreferences.getString(key);
      if (val != null && val != '') {
        notFirstStartUp = true;
      } else {
        notFirstStartUp = true;
        sharedPreferences.setString(key, 'notFirstStartUp').then((value) {
          Navigator.of(context).pushNamed(AppRoutes.ROUTE_PRIVACY_GUIDE);
        });
      }
    }
  }
}
