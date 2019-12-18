import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class AmapState with ChangeNotifier {
  AMapLocation _aMapLocation;

  BuildContext context;

  AMapLocation getAMapLocation(BuildContext context, Widget openDialog) {
    if (_aMapLocation != null) {
      return _aMapLocation;
    } else {
      getLocation(context, openDialog);
    }
  }

  void getLocation(BuildContext context, Widget openDialog) async {
//    try {
//      //权限状态获取
//      PermissionStatus permission =
//          await LocationPermissions().checkPermissionStatus();
//
//      print('当前定位状态$permission');
//
//      //申请定位
//      if (permission != PermissionStatus.granted) {
//        permission = await LocationPermissions().requestPermissions();
//        print('当前定位状态$permission');
//      }
//      //禁用或者询问状态去设置
//      if (permission != PermissionStatus.granted) {
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (_) => openDialog).then((val) {
//          //打开设置失败
//          if (!val) {
//            return;
//          } else {
//            loopQueryStatus();
//            return;
//          }
//        });
//      }
//
//      AMapLocationClient.startup(AMapLocationOption(
//          desiredAccuracy:
//              CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
//      _aMapLocation = await AMapLocationClient.getLocation(true);
//      AMapLocationClient.stopLocation();
//    } catch (e) {
//      print(e);
//    }
//
//    ///通知刷新
//    notifyListeners();
  }

  ///打开应用设置
  Future<bool> openAppSetting() async {
//    bool isOpened = await LocationPermissions().openAppSettings();
//    return isOpened;
  }

  Future<bool> loopQueryStatus() async {
//    print('!1111');
//    LocationPermissions().checkPermissionStatus().then((status) {
//      if (status != PermissionStatus.granted) {
//        Future.delayed(Duration(milliseconds: 1000)).then((e) {
//          loopQueryStatus();
//        });
//      } else {
//        AMapLocationClient.startup(AMapLocationOption(
//            desiredAccuracy:
//                CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
//        AMapLocationClient.getLocation(true).then((val) {
//          _aMapLocation = val;
//          AMapLocationClient.stopLocation();
//
//          ///通知刷新
//          notifyListeners();
//          return true;
//        });
//      }
//    });
  }
}
