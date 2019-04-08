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

  filterByStatuses(String status) async {
    print(status);
    if(status == null) status = 'ALL';
    Map<String, dynamic> data = {};
    if (status != 'ALL') {
      data = {
        'approvalStatuses': [status]
      };
    }
    products.clear();
    print(data);
    productsResponse = await ProductRepositoryImpl().list(data, {});
    print(productsResponse.content);
    products.addAll(productsResponse.content);
    _controller.sink.add(products);
  }

  loadingMoreByStatuses(String status) async {
    if(status == null) status = 'ALL';
    Map<String, dynamic> data = {};
    if (status != 'ALL') {
      data = {
        'approvalStatuses': [status],
      };
    }
    if (productsResponse.number < productsResponse.totalPages - 1) {
      productsResponse = await ProductRepositoryImpl().list(data,{
        'page':productsResponse.number+1,
      });
      products.addAll(productsResponse.content);
    } else {
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _controller.sink.add(products);
  }

  getData(String keyword) async {
    products.clear();
    productsResponse = await ProductRepositoryImpl().list({
      'keyword':keyword,
    }, {});
    print(productsResponse.content);
    products.addAll(productsResponse.content);
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
