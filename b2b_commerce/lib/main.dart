import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/common/app_bloc.dart';
import 'src/client/brand_client.dart';
import 'src/client/factory_client.dart';
import 'src/home/account/login.dart';

void main() async {
  debugInstrumentationEnabled = true;

  // 初始化,检测是否有用户登陆信息
  await UserBLoC.instance.checkLocalUser();

  runApp(BLoCProvider<AppBLoC>(
    bloc: AppBLoC(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: StreamBuilder<UserModel>(
          initialData: UserBLoC.instance.currentUser,
          stream: UserBLoC.instance.stream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            // 未登陆
            if (snapshot.data.type == UserType.ANONYMOUS) {
              return MaterialApp(
                home: B2BLoginPage(),
              );
            } else {
              if (snapshot.data.type == UserType.BRAND) {
                // 品牌
                return BrandClient();
              } else if (snapshot.data.type == UserType.FACTORY) {
                // 工厂
                return FactoryClient();
              }
            }
          }),
    );
  }
}
