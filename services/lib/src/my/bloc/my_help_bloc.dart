import 'dart:async';

import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/my/response/my_response.dart';

class MyHelpBLoC extends BLoCBase {
  // 工厂模式
  factory MyHelpBLoC() => _getInstance();

  static MyHelpBLoC get instance => _getInstance();
  static MyHelpBLoC _instance;

  MyHelpBLoC._internal() {
    // 初始化
  }

  static MyHelpBLoC _getInstance() {
    if (_instance == null) {
      _instance = new MyHelpBLoC._internal();
    }
    return _instance;
  }

  List<UserGuidelineModel> _guideLines = [];

  List<UserGuidelineModel> get guideLines => _guideLines;

  var _controller = StreamController<List<UserGuidelineModel>>.broadcast();

  Stream<List<UserGuidelineModel>> get stream => _controller.stream;

  //锁
  bool lock = false;

  getData() async {
    if (!lock) {
      lock = true;
      //若没有数据则查询
      if (_guideLines.isEmpty) {
        Response<Map<String, dynamic>> response;
        try {
          response = await http$.post(Apis.guideline, data: {
            "keyword": "",
            "groups": ["B2B"]
          }, queryParameters: {
            'page': 0,
            'size': 50
          });
        } on DioError catch (e) {
          print(e);
        }

        if (response != null && response.statusCode == 200) {
          UserGuidelineResponse guideLinesResponse =
              UserGuidelineResponse.fromJson(response.data);
          _guideLines.clear();
          _guideLines.addAll(guideLinesResponse.content);
        }
      }
      _controller.sink.add(_guideLines);
      lock = false;
    }
  }

  void reset() {
    _guideLines.clear();
  }
  // //下拉刷新
  // refreshData(String status) async {
  //   if (!lock) {
  //     //重置信息
  //     // _guideLinesMap[status].data.clear();
  //     // _guideLinesMap[status].currentPage = 0;
  //     // await getData(status);
  //   }
  // }

  //页面控制

  dispose() {
    _controller.close();

    super.dispose();
  }
}
