import 'dart:async';

import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';

class ApparelProductBLoC extends BLoCBase {
  ProductsResponse productsResponse;
  List<ApparelProductModel> products;
  ApparelProductModel currentProduct;

  ApparelProductModel newProduct;

  bool lock = false;

  // 工厂模式
  factory ApparelProductBLoC() => _getInstance();

  static ApparelProductBLoC get instance => _getInstance();
  static ApparelProductBLoC _instance;

  static final Map<String, PageEntry> _productsMap = {
    'ALL': PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>()),
    'approved': PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>()),
    'unapproved': PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>()),
  };

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
    if(!lock){
      lock = true;
      print('${_productsMap[status].data}');
      if(_productsMap[status].data.isEmpty){
        if(status == null) status = 'ALL';
        Map<String, dynamic> data = {};
        if (status != 'ALL') {
          data = {
            'approvalStatuses': [status]
          };
        }

        productsResponse = await ProductRepositoryImpl().list(data, {});
        if(productsResponse != null){
          _productsMap[status].currentPage = productsResponse.number;
          _productsMap[status].totalPages = productsResponse.totalPages;
          _productsMap[status].totalElements = productsResponse.totalElements;
          _productsMap[status].data.clear();
          _productsMap[status].data.addAll(productsResponse.content);
        }
      }
      _controller.sink.add(_productsMap[status].data);
      lock = false;
    }
  }

  loadingMoreByStatuses(String status) async {
    if(!lock) {
      lock = true;
      if (status == null) status = 'ALL';
      Map<String, dynamic> data = {};
      if (status != 'ALL') {
        data = {
          'approvalStatuses': [status],
        };
      }
      if (_productsMap[status].currentPage <
          _productsMap[status].totalPages - 1) {
        productsResponse = await ProductRepositoryImpl().list(data, {
          'page': _productsMap[status].currentPage + 1,
        });
        _productsMap[status].currentPage = productsResponse.number;
        _productsMap[status].totalPages = productsResponse.totalPages;
        _productsMap[status].totalElements = productsResponse.totalElements;
        _productsMap[status].data.addAll(productsResponse.content);
      } else {
        bottomController.sink.add(true);
      }
      loadingController.sink.add(false);
      _controller.sink.add(_productsMap[status].data);
      lock = false;
    }
  }

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

  clear(){
    _controller.sink.add(null);
  }

  clearProductsMap(){
    _productsMap.forEach((key,value){
      _productsMap[key] = PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>());
    });
  }
  clearProductsMapByStatus(String status){
    _productsMap[status] = PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>());
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
