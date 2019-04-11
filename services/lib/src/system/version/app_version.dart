import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AppVersion {
  final BuildContext context;

  AppVersion(this.context);

  void checkVersion(bool ignoreVersionNotification) {
    if (!ignoreVersionNotification) {
      _showNewVersion();
    }
  }

  void _showNewVersion() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          // title: Text('确认取消？'),
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'temp/login_logo.png',
                  package: 'assets',
                  width: 100.0,
                  height: 100.0,
                ),
                Text('版本更新'),
                Text('钉单最新版本来啦，马上更新吧！'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('稍后再说', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('立即更新',
                  style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1))),
              onPressed: () async {
                updateApp(
                    // 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/app-release.apk'
                    'http://47.106.112.137/downloads/app-release.apk');
              },
            ),
          ],
        );
      },
    );
  }

  // //文件下载打开
  Future<String> updateApp(String url) async {
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
    String filePath = "$dir/app.apk}";
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
