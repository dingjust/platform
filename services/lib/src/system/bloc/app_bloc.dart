import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:services/services.dart';

class AppBLoC extends BLoCBase {
  //包信息
  PackageInfo packageInfo;

  ///网络连接状态
  ConnectivityResult _connectivityResult;

  //网络连接状态监听
  StreamSubscription _subscription;

  //记录跳转登录时间
  DateTime _loginPageLogTime;

  // 工厂模式
  factory AppBLoC() => _getInstance();

  static AppBLoC get instance => _getInstance();
  static AppBLoC _instance;

  AppBLoC._internal() {
    // 初始化
    PackageInfo.fromPlatform().then((PackageInfo info) {
      packageInfo = info;
      print(
          'AppName: ${packageInfo.appName} PackageName: ${packageInfo.packageName} Version: ${packageInfo.version} BuildNumber: ${packageInfo.buildNumber}');
    });

    //监听网络连接状态
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      _connectivityResult = result;
      if (result == ConnectivityResult.none) {
        BotToast.showNotification(
          duration: null,
          title: (_) => Text(
            '当前网络不可用,请检查网络设置后重试',
            style: TextStyle(fontSize: 13, color: Colors.red),
          ),
          onlyOne: true,
          trailing: (cancel) => IconButton(
            icon: Icon(Icons.cancel),
            onPressed: cancel,
          ),
        );
      }
    });
  }

  static AppBLoC _getInstance() {
    if (_instance == null) {
      _instance = AppBLoC._internal();
    }
    return _instance;
  }

  ConnectivityResult get getConnectivityResult => _connectivityResult;

  void setConnectivityResult(ConnectivityResult result) {
    _connectivityResult = result;
  }

  DateTime get getLoginPageLogTime => _loginPageLogTime;

  void setloginPageLogTime(DateTime time) {
    _loginPageLogTime = time;
  }

  @override
  void dispose() {
    _subscription.cancel();
  }
}
