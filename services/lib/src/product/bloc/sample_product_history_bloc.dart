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

  var _controller = StreamController<List<SampleBorrowReturnHistoryModel>>.broadcast();

  var _detailController = StreamController<SampleBorrowReturnHistoryModel>();

  Stream<List<SampleBorrowReturnHistoryModel>> get stream => _controller.stream;

  Stream<SampleBorrowReturnHistoryModel> get detailStream => _detailController.stream;

  filterByStatuses(String state) async {
    print(state+'filter');
    Map<String,dynamic> data = {};
    if(state != 'ALL'){
      data = {
        'state':[state],
      };
    }
    products.clear();
    productsResponse = await ProductRepositoryImpl().sampleHistorys(data,{});
    products.addAll(productsResponse.content);
    _controller.sink.add(products);
  }

  loadingMoreByStatuses(String state) async {
    print(state);
    Map<String,dynamic> data = {};
    if(state != 'ALL'){
      data = {
        'state':[state],
      };
    }
    print('${productsResponse.number}、${productsResponse.totalPages}');
    if(productsResponse.number < productsResponse.totalPages-1){
      productsResponse = await ProductRepositoryImpl().sampleHistorys(data,{
        'page':productsResponse.number + 1
      });
      print(productsResponse.content);
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
