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
    'ALL':
    PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>(),status: 'ALL'),
    'approved':
    PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>(),status: 'approved'),
    'unapproved':
    PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>(),status: 'unapproved'),
  };

  static final Map<String, PageEntry> _searchProductsMap = {
    'ALL':
    PageEntry(currentPage: 0, size: 10, data: List<ApparelProductModel>(),status: 'ALL'),
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

  var _controller = StreamController<PageEntry>.broadcast();
  var _searchController = StreamController<PageEntry>.broadcast();

  var _detailController = StreamController<ApparelProductModel>();

  Stream<PageEntry> get stream => _controller.stream;
  Stream<PageEntry> get searchStream => _searchController.stream;

  Stream<ApparelProductModel> get detailStream => _detailController.stream;
//
//  filterByStatuses(String status) async {
//    if (!lock) {
//      lock = true;
//      if (_productsMap[status].data.isEmpty) {
//        if (status == null) status = 'ALL';
//        Map<String, dynamic> data = {};
//        if (status != 'ALL') {
//          data = {
//            'approvalStatuses': [status]
//          };
//        }
//
//        productsResponse = await ProductRepositoryImpl().list(data, {'fields':ApparelProductOptions.DEFAULT});
//        if (productsResponse != null) {
//          _productsMap[status].currentPage = productsResponse.number;
//          _productsMap[status].totalPages = productsResponse.totalPages;
//          _productsMap[status].totalElements = productsResponse.totalElements;
//          _productsMap[status].data.clear();
//          _productsMap[status].data.addAll(productsResponse.content);
//        }
//      }
//      _controller.sink.add(_productsMap[status]);
//      lock = false;
//    }
//  }
//
//  loadingMoreByStatuses(String status) async {
//    if (!lock) {
//      lock = true;
//      if (status == null) status = 'ALL';
//      Map<String, dynamic> data = {};
//      if (status != 'ALL') {
//        data = {
//          'approvalStatuses': [status],
//        };
//      }
//      if (_productsMap[status].currentPage <
//          _productsMap[status].totalPages - 1) {
//        productsResponse = await ProductRepositoryImpl().list(data, {
//          'page': _productsMap[status].currentPage + 1,
//          'fields':ApparelProductOptions.DEFAULT,
//        });
//        _productsMap[status].currentPage = productsResponse.number;
//        _productsMap[status].totalPages = productsResponse.totalPages;
//        _productsMap[status].totalElements = productsResponse.totalElements;
//        _productsMap[status].data.addAll(productsResponse.content);
//      } else {
//        bottomController.sink.add(true);
//      }
//      loadingController.sink.add(false);
//      _controller.sink.add(_productsMap[status]);
//      lock = false;
//    }
//  }
//
  getData(String keyword,{String status}) async {
    if (!lock) {
      print(keyword);
      lock = true;
      products.clear();
      productsResponse = await ProductRepositoryImpl().list({'keyword': keyword,'approvalStatuses': status,}, {});
      products.addAll(productsResponse.content);
      _controller.sink.add(PageEntry(data: products));
      lock = false;
    }
  }

  loadingMore(String keyword,{String status}) async {
    if (productsResponse.number < productsResponse.totalPages - 1) {
      productsResponse = await ProductRepositoryImpl().list({
        'keyword': keyword,
        'approvalStatuses': status,
      }, {
        'page': productsResponse.number + 1,
      });
      products.addAll(productsResponse.content);
    } else {
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _controller.sink.add(PageEntry(data: products));
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

  getDatas({String status,String keyword}) async {
    if (!lock) {
      lock = true;
      if (status == null) status = 'ALL';
      if (_productsMap[status].data.isEmpty) {
        Map<String, dynamic> data = {};
        if (status != 'ALL') {
          data = {
            'approvalStatuses': [status],
            'keyword':keyword ?? '',
          };
        }

        productsResponse = await ProductRepositoryImpl().list(data, {'fields':ApparelProductOptions.DEFAULT});
        if (productsResponse != null) {
          _productsMap[status].currentPage = productsResponse.number;
          _productsMap[status].totalPages = productsResponse.totalPages;
          _productsMap[status].totalElements = productsResponse.totalElements;
          _productsMap[status].data.clear();
          _productsMap[status].data.addAll(productsResponse.content);
        }
      }

      _controller.sink.add(_productsMap[status]);

      lock = false;
    }
  }

  getDatasLoadingMore({String status,String keyword}) async {
    if (!lock) {
      lock = true;
      if (status == null) status = 'ALL';
      Map<String, dynamic> data = {};
      if (status != 'ALL') {
        data = {
          'approvalStatuses': [status],
          'keyword':keyword ?? '',
        };
      }
      if (_productsMap[status].currentPage <
          _productsMap[status].totalPages - 1) {
        productsResponse = await ProductRepositoryImpl().list(data, {
          'page': _productsMap[status].currentPage + 1,
          'fields':ApparelProductOptions.DEFAULT,
        });
        _productsMap[status].currentPage = productsResponse.number;
        _productsMap[status].totalPages = productsResponse.totalPages;
        _productsMap[status].totalElements = productsResponse.totalElements;
        _productsMap[status].data.addAll(productsResponse.content);
      } else {
        bottomController.sink.add(true);
      }
      loadingController.sink.add(false);

      _controller.sink.add(_productsMap[status]);

      lock = false;
    }
  }

  clear() {
    _controller.sink.add(null);
  }

  ///重置数据
  clearProductsMap() {
    _productsMap.forEach((key, value) {
      value.data.clear();
      value.currentPage = 0;
    });
  }

  clearProductsMapByStatus(String status) {
    _productsMap[status].data.clear();
    _productsMap[status].currentPage = 0;
  }

  ///重置数据
  clearSearchProductsMap() {
    _searchProductsMap.forEach((key, value) {
      value.data.clear();
      value.currentPage = 0;
    });
  }

  clearSearchProductsMapByStatus(String status) {
    _searchProductsMap[status].data.clear();
    _searchProductsMap[status].currentPage = 0;
  }
}
