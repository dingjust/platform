import 'package:amap_location/amap_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';

class AmapState with ChangeNotifier {
  AMapLocation _aMapLocation;

  BuildContext context;

  String _city;

  double _longitude;

  double _latitude;

  ///默认广州经纬度
  double DEFAULT_LONGITUDE = 113.264434;

  double DEFAULT_LATITUDE = 23.129162;

  ///获取经度
  double get longitude {
    if (_longitude != null && _longitude != 0) {
      return _longitude;
    }
    return DEFAULT_LONGITUDE;
  }

  ///获取纬度
  double get latitude {
    if (_latitude != null && _latitude != 0) {
      return _latitude;
    }
    return DEFAULT_LATITUDE;
  }

  String get city {
    if (_city != null) {
      return _city;
    }
    return '广州';
  }

  AMapLocation getAMapLocation({BuildContext context, Widget openDialog}) {
    if (_aMapLocation != null) {
      return _aMapLocation;
    } else if (context != null && openDialog != null) {
      getLocation(context, openDialog);
      return AMapLocation(
          city: '广州',
          AOIName: '广州',
          longitude: DEFAULT_LONGITUDE,
          latitude: DEFAULT_LATITUDE);
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
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          AMapLocationClient.startup(AMapLocationOption(
              desiredAccuracy:
              CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
          _aMapLocation = await AMapLocationClient.getLocation(true);
          _latitude = _aMapLocation.latitude;
          _longitude = _aMapLocation.longitude;
          AMapLocationClient.stopLocation();
        } else {
          permission = await LocationPermissions().requestPermissions();
        }
        print('当前定位状态--2$permission');
      }

      //禁用或者询问状态去设置
      if (permission != PermissionStatus.granted) {
        bool result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => openDialog);

        //打开设置失败
        if (!result) {
          return;
        } else {
          bool queryResult = await loopQueryStatus();
          return;
        }
      }

      AMapLocationClient.startup(AMapLocationOption(
          desiredAccuracy:
              CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
      _aMapLocation = await AMapLocationClient.getLocation(true);

      if (_aMapLocation == null) {
        _aMapLocation = AMapLocation(
            city: '广州',
            AOIName: '广州',
            longitude: DEFAULT_LONGITUDE,
            latitude: DEFAULT_LATITUDE);
      } else {
        _latitude = _aMapLocation.latitude;
        _longitude = _aMapLocation.longitude;
      }
      AMapLocationClient.stopLocation();
    } catch (e) {
      print(e);
    } finally {
      ///通知刷新
      notifyListeners();
    }
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
    _longitude = longitude;
    _latitude = latitude;
    if (city != null) {
      _city = city;
    }
    notifyListeners();
  }
}
