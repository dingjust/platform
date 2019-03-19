import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class ApparelProductBLoC extends BLoCBase {
  ProductsResponse productsResponse;
  List<ApparelProductModel> products;
  ApparelProductModel currentProduct;

  ApparelProductModel newProduct;

  // 工厂模式
  factory ApparelProductBLoC() => _getInstance();

  static ApparelProductBLoC get instance => _getInstance();
  static ApparelProductBLoC _instance;

  ApparelProductBLoC._internal() {
    // 初始化
    products = List<ApparelProductModel>();
    currentProduct = ApparelProductModel.empty();
    productsResponse = ProductsResponse(0, 10, 0, 0, []);

    newProduct = ApparelProductModel();
  }

  static ApparelProductBLoC _getInstance() {
    if (_instance == null) {
      _instance = ApparelProductBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller = StreamController<List<ApparelProductModel>>.broadcast();

  var _detailController = StreamController<ApparelProductModel>();

  Stream<List<ApparelProductModel>> get stream => _controller.stream;

  Stream<ApparelProductModel> get detailStream => _detailController.stream;

  filterByStatuses() async {
    products.clear();
    productsResponse = await ProductRepositoryImpl().list({},{
      'approvalStatuses':['approved']
    });
    products.addAll(productsResponse.content);
    _controller.sink.add(products);
  }

  loadingMoreByStatuses() async {
    if(productsResponse.number < productsResponse.totalPages-1){
      productsResponse = await ProductRepositoryImpl().list({},{
        'page':productsResponse.number+1,
      });
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
