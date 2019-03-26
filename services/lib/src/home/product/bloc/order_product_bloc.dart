import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class OrderByProductBLoc extends BLoCBase {
  // 工厂模式
  factory OrderByProductBLoc() => _getInstance();

  static OrderByProductBLoc get instance => _getInstance();
  static OrderByProductBLoc _instance;

  OrderByProductBLoc._internal() {
    // 初始化
  }

  static OrderByProductBLoc _getInstance() {
    if (_instance == null) {
      _instance = new OrderByProductBLoc._internal();
    }
    return _instance;
  }

  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;

  var _controller = StreamController<List<ProductModel>>.broadcast();

  Stream<List<ProductModel>> get stream => _controller.stream;

  // var conditionController = StreamController<FilterConditionEntry>.broadcast();

  // Stream<FilterConditionEntry> get conditionStream =>
  //     conditionController.stream;

  getData() async {
    
  }

  loadingMore() async {
    
  }

  clear() async {
    //清空
    _products.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData() async {
   
  }

  //页面控制

  //记录是否已经到底
  bool _isBottom = false;

  bool get isBottom => _isBottom;

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
