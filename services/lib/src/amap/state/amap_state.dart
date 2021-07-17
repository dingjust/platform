import 'package:amap_location/amap_location.dart';
import 'package:bot_toast/bot_toast.dart';
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
      //IOS进来不取定位权限
      if (defaultTargetPlatform == TargetPlatform.android) {
        getLocation(context, openDialog);
      }
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
          _city = _aMapLocation.city;
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
        BotToast.showCustomText(
          onlyOne: true,
          duration: null,
          clickClose: false,
          crossPage: false,
          backgroundColor: Colors.black38,
          toastBuilder: (cancelFunc) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            // title: Text('钉单正在请求定位权限,请设置'),
            content: Text('钉单正在请求定位权限,请设置'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  cancelFunc();
                },
                child: const Text('忽略', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  cancelFunc();
                  bool result = await openAppSetting();
                  if (result ?? false) {
                    bool queryResult = await loopQueryStatus();
                  }
                },
                child: const Text(
                  '设置',
                ),
              ),
            ],
          ),
        );
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
        _city = _aMapLocation.city;
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
