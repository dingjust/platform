import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class ApparelProductSearchResultBLoC extends BLoCBase {
  ProductsResponse productsResponse;
  List<ApparelProductModel> products;
  ApparelProductModel currentProduct;

  ApparelProductModel newProduct;

  bool lock = false;

  // 工厂模式
  factory ApparelProductSearchResultBLoC() => _getInstance();

  static ApparelProductSearchResultBLoC get instance => _getInstance();
  static ApparelProductSearchResultBLoC _instance;

  ApparelProductSearchResultBLoC._internal() {
    // 初始化
    products = List<ApparelProductModel>();
    currentProduct = ApparelProductModel.empty();
    productsResponse = ProductsResponse(0, 10, 0, 0, []);

    newProduct = ApparelProductModel();
  }

  static ApparelProductSearchResultBLoC _getInstance() {
    if (_instance == null) {
      _instance = ApparelProductSearchResultBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller = StreamController<List<ApparelProductModel>>.broadcast();

  Stream<List<ApparelProductModel>> get stream => _controller.stream;

  getData(String keyword) async {
    print(lock);
    if(!lock){
      print(keyword);
      lock=true;
      products.clear();
      productsResponse = await ProductRepositoryImpl().list({
        'keyword':keyword
      }, {});
      print(productsResponse.content);
      products.addAll(productsResponse.content);
      _controller.sink.add(products);
      lock = false;
    }
  }

  loadingMore(String keyword) async {
    if (productsResponse.number < productsResponse.totalPages - 1) {
      productsResponse = await ProductRepositoryImpl().list({
        'keyword':keyword
      },{
        'page':productsResponse.number+1,
      });
      products.addAll(productsResponse.content);
    } else {
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _controller.sink.add(products);
  }

  dispose() {
    _controller.close();

    super.dispose();
  }
}
