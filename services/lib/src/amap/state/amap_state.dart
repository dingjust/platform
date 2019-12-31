import 'package:amap_location/amap_location.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class AmapState with ChangeNotifier {
  AMapLocation _aMapLocation;

  BuildContext context;

  String _city;

  AMapLocation getAMapLocation({BuildContext context, Widget openDialog}) {
    if (_aMapLocation != null) {
      return _aMapLocation;
    } else if (context != null && openDialog != null) {
      getLocation(context, openDialog);
      return AMapLocation(
          city: '广州',
          AOIName: '广州',
          longitude: 113.264434,
          latitude: 23.129162);
    }
  }

  void getLocation(BuildContext context, Widget openDialog) async {
    try {
      //权限状态获取
      PermissionStatus permission =
          await LocationPermissions().checkPermissionStatus();

      print('当前定位状态$permission');

      //申请定位
      if (permission != PermissionStatus.granted) {
        permission = await LocationPermissions().requestPermissions();
        print('当前定位状态$permission');
      }
      //禁用或者询问状态去设置
      if (permission != PermissionStatus.granted) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => openDialog).then((val) {
          //打开设置失败
          if (!val) {
            return;
          } else {
            loopQueryStatus();
            return;
          }
        });
      }

      AMapLocationClient.startup(AMapLocationOption(
          desiredAccuracy:
              CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
      _aMapLocation = await AMapLocationClient.getLocation(true);
      if (_aMapLocation == null) {
        _aMapLocation = AMapLocation(
            city: '广州',
            AOIName: '广州',
            longitude: 113.264434,
            latitude: 23.129162);
      }
      AMapLocationClient.stopLocation();
    } catch (e) {
      print(e);
    }

    ///通知刷新
    notifyListeners();
  }

  ///打开应用设置
  Future<bool> openAppSetting() async {
    bool isOpened = await LocationPermissions().openAppSettings();
    return isOpened;
  }

  Future<bool> loopQueryStatus() async {
    LocationPermissions().checkPermissionStatus().then((status) {
      if (status != PermissionStatus.granted) {
        Future.delayed(Duration(milliseconds: 1000)).then((e) {
          loopQueryStatus();
        });
      } else {
        AMapLocationClient.startup(AMapLocationOption(
            desiredAccuracy:
                CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
        AMapLocationClient.getLocation(true).then((val) {
          _aMapLocation = val;
          AMapLocationClient.stopLocation();

          ///通知刷新
          notifyListeners();
          return true;
        });
      }
    });
  }

  ///获取经度
  double get longitude {
    if (_aMapLocation != null) {
      print('=====================');
      print(_aMapLocation.AOIName);
      return _aMapLocation.longitude ?? 113.264434;
    } else {
      return 113.264434;
    }
  }

  ///获取纬度
  double get latitude {
    if (_aMapLocation != null) {
      return _aMapLocation.latitude ?? 23.129162;
    } else {
      return 23.129162;
    }
  }

  String get city {
    if (_city != null) {
      return _city;
    } else if (_aMapLocation != null) {
      return _aMapLocation.city ?? '广州';
    } else {
      return '广州';
    }
  }

  void setCity(String city) {
    _city = city;
  }

  ///覆盖定位信息
  void setAMapLocation(
      {String aOIName, double longitude, double latitude, String city}) {
    _aMapLocation = AMapLocation(
        city: city ?? this.city,
        AOIName: aOIName ?? _aMapLocation.AOIName,
        longitude: longitude,
        latitude: latitude);
    notifyListeners();
  }
}
