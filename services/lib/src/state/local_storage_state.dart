import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///本地记录
class LocalStorageState with ChangeNotifier {
  static const String key = 'notFirstStartUp';

  ///非第一次启动
  bool _notFirstStartUp;

  bool get notFirstStartUp {
    if (_notFirstStartUp == null) {
      getNotFirstStartUp();
    }
    return _notFirstStartUp;
  }

  Future<bool> getNotFirstStartUp() async {
    if (notFirstStartUp != null) {
      return true;
    } else {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String val = sharedPreferences.getString(key);
      if (val != null && val != '') {
        _notFirstStartUp = true;
        notifyListeners();
        return true;
      }

      return false;
    }
  }
}
