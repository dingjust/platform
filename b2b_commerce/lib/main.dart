import 'package:b2b_commerce/src/client/brand_client.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'src/common/app_bloc.dart';

void main() {
  debugInstrumentationEnabled = true;

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
  int _currentIndex = 0;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<UserBLoC>(
      bloc: UserBLoC.instance,
      child: StreamBuilder<UserModel>(
          initialData: UserBLoC.instance.currentUser,
          stream: UserBLoC.instance.stream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            //品牌
            if (snapshot.data.userType == UserType.BRAND) {
              return BrandClient();
            }
            //TODO:工厂

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
