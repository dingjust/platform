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

  //假数据，待删除
  ProductModel mockData1() {
    return ProductModel(
      name: '冬季女棉服',
//      thumbnail:
//          'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      minPrice: 99.0,
      maxPrice: 500.0,
    );
  }

  ProductModel mockData2() {
    return ProductModel(
      name: 'Vero Moda秋季新款高冷气质女装百褶针织连衣裙女',
//      thumbnail:
//          'https://img.alicdn.com/imgextra/i4/17971277/O1CN01Qgn0h01LIuGFhUVFf_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      minPrice: 99.0,
      maxPrice: 500.0,
    );
  }

  getData() async {
    _products.clear();
    //若没有数据则查询
    if (_products.isEmpty) {
      // TODO: 分页拿数据，response.data;
      _products.addAll(await Future.delayed(const Duration(seconds: 1), () {
        List<ProductModel> list = [];
        for (int i = 0; i < 10; i++) {
          list.add(mockData1());
        }
        return list;
      }));
    }
    _controller.sink.add(_products);
  }

  loadingMore() async {
    //模拟数据到底
    if (_products.length < 20) {
      _products.addAll(await Future.delayed(const Duration(seconds: 1), () {
        return [mockData1(), mockData1()];
      }));
    } else {
      _isBottom = true;
      //通知显示已经到底部
      _bottomController.sink.add(isBottom);
    }
    loadingEnd();
    _controller.sink.add(_products);
  }

  clear() async {
    //清空
    _products.clear();
    _controller.sink.add(null);
  }

  //下拉刷新
  Future refreshData() async {
    _isBottom = false;
    _products.clear();
    _products.addAll(await Future.delayed(const Duration(seconds: 1), () {
      List<ProductModel> list = [];
      for (int i = 0; i < 6; i++) {
        list.add(mockData2());
      }
      return list;
    }));
    _controller.sink.add(_products);
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
