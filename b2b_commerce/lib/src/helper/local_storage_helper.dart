import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper with ChangeNotifier {
  ///用户同意《隐私政策》时间
  static const String key = 'privacyAgreeTime';

  String privacyAgreeTime;

  String getPrivacyAgreeTime() {
    if (privacyAgreeTime == null) {
      getLocalPrivacyAgreeTime();
    }
    return privacyAgreeTime;
  }

  Future<String> getLocalPrivacyAgreeTime() async {
    if (privacyAgreeTime == null || privacyAgreeTime == '') {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String val = sharedPreferences.getString(key);
      if (val != null && val != '') {
        privacyAgreeTime = val;
        notifyListeners();
      }
    }
    return privacyAgreeTime;
  }

  Future<bool> setPrivacyAgreeTime() async {
    String val = DateTime.now().toIso8601String();
    privacyAgreeTime = val;
    notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString(key, val);
  }
}
