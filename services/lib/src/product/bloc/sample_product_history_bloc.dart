import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';

class SampleProductHistoryBLoC extends BLoCBase {
  SampleProductHistorysResponse productsResponse;
  List<SampleBorrowReturnHistoryModel> products;
  SampleBorrowReturnHistoryModel currentProduct;

  SampleBorrowReturnHistoryModel newProduct;

  // 工厂模式
  factory SampleProductHistoryBLoC() => _getInstance();

  static SampleProductHistoryBLoC get instance => _getInstance();
  static SampleProductHistoryBLoC _instance;

  SampleProductHistoryBLoC._internal() {
    // 初始化
    products = List<SampleBorrowReturnHistoryModel>();
    currentProduct = SampleBorrowReturnHistoryModel();
    productsResponse = SampleProductHistorysResponse(0, 10, 0, 0, []);

    newProduct = SampleBorrowReturnHistoryModel();
  }

  static SampleProductHistoryBLoC _getInstance() {
    if (_instance == null) {
      _instance = SampleProductHistoryBLoC._internal();
    }
    return _instance;
  }

  //TODO 清空表单数据
  void clearNewProduct() {}

  var _controller =
      StreamController < List < SampleBorrowReturnHistoryModel

  >

  >

      .

  broadcast();

  var _detailController = StreamController<SampleBorrowReturnHistoryModel>();

  Stream<List<SampleBorrowReturnHistoryModel>> get stream => _controller.stream;

  Stream<SampleBorrowReturnHistoryModel> get detailStream =>
      _detailController.stream;

  filterByStatuses(String state, String type) async {
    Map<String, dynamic> data = {};
    if (state != 'ALL') {
      data = {
        'state': state,
      };
    }
    data['type'] = type.split('.')[1];
    products.clear();
    productsResponse = await ProductRepositoryImpl().sampleHistorys(data, {});
    products.addAll(productsResponse.content);
    products.forEach((product) {
      print(SampleBorrowReturnHistoryModel.toJson(product));
    });
    _controller.sink.add(products);
  }

  loadingMoreByStatuses(String state, String type) async {
    Map<String, dynamic> data = {};
    if (state != 'ALL') {
      data = {
        'state': state,
        'type': type,
      };
    }
    print('${productsResponse.number}、${productsResponse.totalPages}');
    if (productsResponse.number < productsResponse.totalPages - 1) {
      productsResponse = await ProductRepositoryImpl()
          .sampleHistorys(data, {'page': productsResponse.number + 1});
      print(productsResponse.content);
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
  void reset() {
    // 初始化
    products = List<SampleBorrowReturnHistoryModel>();
    currentProduct = SampleBorrowReturnHistoryModel();
    productsResponse = SampleProductHistorysResponse(0, 10, 0, 0, []);
    newProduct = SampleBorrowReturnHistoryModel();
  }

  dispose() {
    _controller.close();
    _detailController.close();

    super.dispose();
  }
}
