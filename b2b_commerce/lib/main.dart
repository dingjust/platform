import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/app/app.dart';
import 'package:b2b_commerce/src/common/app_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/_shared/error/b2b_error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Provider.debugCheckInvalidValueType = null;

  debugInstrumentationEnabled = true;

  // 初始化,检测是否有用户登录信息
  await UserBLoC.instance.checkLocalUser();

  //头部状态栏阴影
  TargetPlatform platform = defaultTargetPlatform;
  if (platform != TargetPlatform.iOS) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else {
    //IOS高德定位注册KEY
    AMapLocationClient.setApiKey(GlobalConfigs.AMAP_LOCATION_KEY_IOS);
  }

  //错误页面
  if (!GlobalConfigs.DEBUG) {
    ErrorWidget.builder =
        (FlutterErrorDetails flutterErrorDetails) => B2BErrorPage();
  }

  //强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(BLoCProvider<AppBLoC>(
      bloc: AppBLoC.instance,
      child: MultiProvider(
        providers: AppProvider.providers,
        child: MyApp(),
      ),
    ));
  });
}