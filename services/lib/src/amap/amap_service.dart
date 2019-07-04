import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:services/src/amap/amap_response.dart';
import 'package:services/src/api/apis.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:amap_location/amap_location.dart';
import 'package:permission_handler/permission_handler.dart';

class AmapService {
  // 工厂模式
  factory AmapService() => _getInstance();

  static AmapService get instance => _getInstance();
  static AmapService _instance;

  var options;

  /// 初始化
  AmapService._internal() {}

  static AmapService _getInstance() {
    if (_instance == null) {
      _instance = new AmapService._internal();
    }
    return _instance;
  }

  ///获取高德地址输入提示
  Future<AmapResponse> inputtips(String keywords, {String city}) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(Apis.AMAP_TIP_API, data: {
        'output': 'json',
        'key': GlobalConfigs.AMAP_TIP_KEY,
        'keywords': keywords ?? '',
        'city': city ?? ''
      });
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      AmapResponse amapResponse = AmapResponse.fromJson(response.data);
      return amapResponse;
    } else {
      return null;
    }
  }

  ///获取高德周边提示
  Future<AmapAroundResponse> aroundTips(String location,
      {int radius = 50}) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(Apis.AMAP_AROUND_API, data: {
        'key': GlobalConfigs.AMAP_TIP_KEY,
        'location': location,
        'radius': radius,
        'extensions': 'base'
      });
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      AmapAroundResponse amapResponse =
          AmapAroundResponse.fromJson(response.data);
      return amapResponse;
    } else {
      return null;
    }
  }

  Future<AMapLocation> location() async {
    AMapLocationClient.startup(AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    //Android获取权限，IOS不需要
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.locationWhenInUse);
    print('check==============');

    if (permission != PermissionStatus.granted) {
      print('request==============');

      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationWhenInUse]);

      print('request==============');

      if (permissions[PermissionGroup.locationWhenInUse] !=
          PermissionStatus.granted) {
        print('定位权限失败');
        return null;
      }
    }
    //END

    AMapLocation aMapLocation = await AMapLocationClient.getLocation(true);
    AMapLocationClient.stopLocation();
    print('${aMapLocation.longitude}           ${aMapLocation.latitude}');
    return aMapLocation;
  }
}
