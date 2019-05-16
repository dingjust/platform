import 'package:amap_base/amap_base.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:services/src/amap/amap_response.dart';
import 'package:services/src/net/http_managertory AmapService() => _getInstance();

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
  Future<AmapResponse> inputtips(String keywords) async {
    Response<Map<String, dynamic>> response;
    try {
      response = await http$.get(GlobalConfigs.AMAP_TIP_API, data: {
        'output': 'json',
        'key': GlobalConfigs.AMAP_TIP_KEY,
        'keywords': keywords ?? ''
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

  Future<AMapLocation> location() async {
    AMapLocationClient.startup(AMapLocationOption(
        desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
    bool hasPermission =
        await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
    if (!hasPermission) {
      PermissionStatus requestPermissionResult =
          await SimplePermissions.requestPermission(
              Permission.WhenInUseLocation);
      if (requestPermissionResult != PermissionStatus.authorized) {
        print('定位权限失败');
        return null;
      }
    }
    AMapLocation aMapLocation = await AMapLocationClient.getLocation(true);
    AMapLocationClient.stopLocation();
    print('${aMapLocation.longitude}           ${aMapLocation.latitude}');
    return aMapLocation;
  }
}
