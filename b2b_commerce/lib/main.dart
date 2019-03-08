import 'package:b2b_commerce/src/client/brand_client.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/common/app_bloc.dart';

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
            //品牌
            if (snapshot.data.type == UserType.BRAND) {
              return BrandClient();
            }
            //TODO:工厂z
            //未登陆
            else {
              return MaterialApp(
                home: B2BLoginPage(),
              );
            }
          }),
    );
  }
}
