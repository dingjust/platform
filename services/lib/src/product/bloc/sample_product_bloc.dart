import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class SampleProductBLoC extends BLoCBase {
  SampleProductsResponse productsResponse;
  List<SampleProductModel> products;
  SampleProductModel currentProduct;

  SampleProductModel newProduct;

  // 工厂模式
  factory SampleProductBLoC() => _getInstance();

  static SampleProductBLoC get instance => _getInstance();
  static SampleProductBLoC _instance;
  bool lock = false;

  SampleProductBLoC._internal() {
    // 初始化
    products = List<SampleProductModel>();
    currentProduct = SampleProductModel();
    productsResponse = SampleProductsResponse(0, 10, 0, 0, []);

    newProduct = SampleProductModel();
  }

  static SampleProductBLoC _getInstance() {
    if (_instance == null) {
      _instance = SampleProductBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller = StreamController<List<SampleProductModel>>.broadcast();

  var _detailController = StreamController<SampleProductModel>();

  Stream<List<SampleProductModel>> get stream => _controller.stream;

  Stream<SampleProductModel> get detailStream => _detailController.stream;

  filterByStatuses() async {
    if(!lock){
      lock = true;
      products.clear();
      productsResponse = await ProductRepositoryImpl().samples({});
      products.addAll(productsResponse.content);
      _controller.sink.add(products);
      lock = false;
    }

  }

  loadingMoreByStatuses() async {
    if(productsResponse.number < productsResponse.totalPages-1){
//      productsResponse = await ProductRepositoryImpl().list({
//        'page':productsResponse.number+1,
//      },{});
      products.addAll(productsResponse.content);
    }else{
      _bottomController.sink.add(true);
    }

    _loadingController.sink.add(false);
    _controller.sink.add(products);
  }

  //下拉刷新
//  Future refreshData() async {
//    productsResponse = await ProductRepositoryImpl().list({},{});
//    _controller.sink.add(productsResponse.content);
//  }

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
    _detailController.close();
    _loadingController.close();
    _bottomController.close();
    _toTopBtnController.close();
    _returnToTopController.close();
  }
}
