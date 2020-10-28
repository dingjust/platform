import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/src/api/apis.dart';
import 'package:services/src/net/http_manager.dart';
import 'package:services/src/system/version/app_response.dart';
import 'package:services/src/user/bloc/user_bloc.dart';
import 'package:store_redirect/store_redirect.dart';

class AppVersionHelper {
  //是否忽略更新提示
  bool ignoreVersionNotification;

  TargetPlatform platform = defaultTargetPlatform;

  AppVersionResponse appVersionInfo;

  AppVersionHelper({this.ignoreVersionNotification = false});

  Future<AppVersionResponse> getAppVersionInfo(String name) async {
    Response response;
    try {
      response = await http$.get(
        Apis.appVersions(
            name, platform != TargetPlatform.iOS ? 'ANDROID' : 'IOS'),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      appVersionInfo = AppVersionResponse.fromJson(response.data);
      return appVersionInfo;
    }
    return appVersionInfo;
  }

  Future<bool> checkVersion(
      BuildContext context, String packageVersion, String name,
      {bool showNowMessage = false}) async {
    if (appVersionInfo != null) {
      //比较版本
      if (VersionUtil.compareVersion(
              appVersionInfo.releaseVersion, packageVersion) ==
          1) {
        if (platform != TargetPlatform.iOS) {
          _showNewVersionForAndroid(context, appVersionInfo.releaseVersion,
              appVersionInfo.description, appVersionInfo.url,
              force: appVersionInfo.force ?? false);
        } else {
          _showNewVersionForIos(context, appVersionInfo.releaseVersion,
              appVersionInfo.description, appVersionInfo.url,
              force: appVersionInfo.force ?? false);
        }
        return false;
      } else {
        if (showNowMessage)
          _showMessage(context, appVersionInfo.releaseVersion);
        return true;
      }
    }
    print('获取appVersionInfo为null');
    return true;
  }

  void _showMessage(BuildContext context, String releaseVersion) {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: true,
        toastBuilder: (cancelFunc) => AlertDialog(
              content: Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('已经是最新版本,当前版本：${releaseVersion}'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('确定', style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    cancelFunc();
                  },
                ),
              ],
            ));
  }

  _jumpToAppStore() async {
    // const url = 'itms-apps://itunes.apple.com/cn/app/钉单/id1459206673?mt=8';
    StoreRedirect.redirect(
        androidAppId: "net.nbyjy.b2b", iOSAppId: "1459206673");
  }

  void _showNewVersionForIos(BuildContext context, String releaseVersion,
      String description, String url,
      {bool force = false}) {
    if (ignoreVersionNotification) {
      return;
    }
    BotToast.showEnhancedWidget(
        onlyOne: true,
        duration: null,
        crossPage: true,
        clickClose: force ? false : true,
        backButtonBehavior: BackButtonBehavior.ignore,
        allowClick: force ? false : true,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                contentPadding: EdgeInsets.only(top: 10),
                content: Container(
                  height: 250,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '更新',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView(
                          children: <Widget>[
                            Text('版本更新'),
                            Text('新版本：${releaseVersion}'),
                            Text('版本说明：'),
                            Column(children: getDecriptionRows(description)),
                            Text('钉单最新版本来啦，马上更新吧！'),
                          ],
                        ),
                      )),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey[300], width: 0.5))),
                        child: Row(
                          children: <Widget>[
                            (force != null && force)
                                ? Container()
                                : Expanded(
                                    child: FlatButton(
                                      child: Text('稍后再说',
                                          style: TextStyle(color: Colors.grey)),
                                      onPressed: () {
                                        ignoreVersionNotification = true;
                                        UserBLoC.instance
                                            .ignoreVersionNotification = true;
                                        cancelFunc();
                                      },
                                    ),
                                  ),
                            (force != null && force)
                                ? Container()
                                : Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.grey[300],
                                                width: 0.5))),
                                  ),
                            Expanded(
                              child: FlatButton(
                                child: Text('前往AppStore',
                                    style: TextStyle(color: Colors.blue)),
                                onPressed: () {
                                  _jumpToAppStore();
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void _showNewVersionForAndroid(BuildContext context, String releaseVersion,
      String description, String url,
      {bool force = false}) {
    if (ignoreVersionNotification) {
      return;
    }
    BotToast.showEnhancedWidget(
        onlyOne: true,
        duration: null,
        crossPage: true,
        clickClose: force ? false : true,
        backButtonBehavior: BackButtonBehavior.ignore,
        allowClick: force ? false : true,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) => WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                contentPadding: EdgeInsets.only(top: 10),
                content: Container(
                  height: 250,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Image.asset(
                      //   'temp/login_logo.png',
                      //   package: 'assets',
                      //   width: 100.0,
                      //   height: 100.0,
                      // ),
                      Text(
                        '更新',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView(
                          children: <Widget>[
                            Text('版本更新'),
                            Text('新版本：${releaseVersion}'),
                            Text('版本说明：'),
                            Column(children: getDecriptionRows(description)),
                            Text('钉单最新版本来啦，马上更新吧！'),
                          ],
                        ),
                      )),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey[300], width: 0.5))),
                        child: Row(
                          children: <Widget>[
                            (force != null && force)
                                ? Container()
                                : Expanded(
                                    child: FlatButton(
                                      child: Text('稍后再说',
                                          style: TextStyle(color: Colors.grey)),
                                      onPressed: () {
                                        ignoreVersionNotification = true;
                                        UserBLoC.instance
                                            .ignoreVersionNotification = true;
                                        cancelFunc();
                                      },
                                    ),
                                  ),
                            (force != null && force)
                                ? Container()
                                : Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.grey[300],
                                                width: 0.5))),
                                  ),
                            Expanded(
                              child: FlatButton(
                                child: Text('立即更新',
                                    style: TextStyle(color: Colors.red)),
                                onPressed: () async {
                                  cancelFunc();
                                  updateApp(context, url);
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  List<Widget> getDecriptionRows(String description) {
    List<Widget> result = description
        .split('\\n')
        .where((str) => str != '')
        .map((str) => Text('$str'))
        .toList();
    return result;
  }

  // //文件下载打开
  Future<String> updateApp(BuildContext context, String url) async {
    final StreamController _streamController =
        StreamController<double>.broadcast();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            StreamBuilder<double>(
                stream: _streamController.stream,
                initialData: 0.0,
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '下载中',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Center(
                          child: LinearProgressIndicator(
                            value: snapshot.data,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('进度:', style: TextStyle(fontSize: 12)),
                            Text('${((snapshot.data / 1) * 100).round()}%',
                                style: TextStyle(fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  );
                })
          ],
        );
      },
    );

    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/app.apk";
    var dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };
    try {
      Response response = await dio.download(url, filePath,
          onReceiveProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        _streamController.sink.add(received / total);
      });
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    //打开文件
    OpenFile.open(filePath);
    return filePath;
  }
}
