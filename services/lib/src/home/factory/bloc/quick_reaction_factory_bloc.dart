import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class FactoryBLoC extends BLoCBase {
  // 工厂模式
  factory FactoryBLoC() => _getInstance();

  static FactoryBLoC get instance => _getInstance();
  static FactoryBLoC _instance;

  FactoryBLoC._internal() {
    // 初始化
  }

  static FactoryBLoC _getInstance() {
    if (_instance == null) {
      _instance = new FactoryBLoC._internal();
    }
    return _instance;
  }

  List<FactoryModel> _factories = [];

  List<FactoryModel> get factories => _factories;

  var _controller = StreamController<List<FactoryModel>>.broadcast();

  Stream<List<FactoryModel>> get stream => _controller.stream;

  var conditionController = StreamController<FilterConditionEntry>.broadcast();

  Stream<FilterConditionEntry> get conditionStream =>
      conditionController.stream;

  filterByCondition({String condition, bool isDESC}) async {}

  loadingMoreByCondition({String condition, bool isDESC}) async {}

  clear() async {
    //清空
    _factories.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData({String condition, bool isDESC}) async {}

  //页面控制

  var _loadingController = StreamController<bool>.broadcast();
  var _bottomController = StreamController<bool>.broadcast();
  var _toTopBtnController = StreamController<bool>.broadcast();
  var _returnToTopController = StreamController<bool>.broadcast();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get bottomStream => _bottomController.stream;

  Stream<bool> get toTopBtnStream => _toTopBtnController.stream;

  Stream<bool> get returnToTopStream => _returnToTopController.stream;

  loadingStart() async {
    _loadingController.sink.add(true);
  }

  loadingEnd() async {
    _loadingController.sink.add(false);
  }

  showToTopBtn() async {
    _toTopBtnController.sink.add(true);
  }

  hideToTopBtn() async {
    _toTopBtnController.sink.add(false);
  }

  returnToTop() async {
    _returnToTopController.sink.add(true);
  }

  dispose() {
    _controller.close();
  }
}
