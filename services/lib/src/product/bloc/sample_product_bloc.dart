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
    if (!lock) {
      lock = true;
      products.clear();
      productsResponse = await ProductRepositoryImpl().samples({});
      products.addAll(productsResponse.content);
      _controller.sink.add(products);
      lock = false;
    }
  }

  loadingMoreByStatuses() async {
    if (productsResponse.number < productsResponse.totalPages - 1) {
      productsResponse = await ProductRepositoryImpl().samples({
        'page':productsResponse.number+1,
      });
      products.addAll(productsResponse.content);
    } else {
      bottomController.sink.add(true);
    }

    loadingController.sink.add(false);
    _controller.sink.add(products);
  }

  //下拉刷新
//  Future refreshData() async {
//    productsResponse = await ProductRepositoryImpl().list({},{});
//    _controller.sink.add(productsResponse.content);
//  }

  dispose() {
    _controller.close();
    _detailController.close();

    super.dispose();
  }
}
