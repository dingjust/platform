import 'dart:async';

import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/order/PageEntry.dart';

class ApparelProductBLoC extends BLoCBase {
  ProductsResponse productsResponse;
  ProductsResponse searchProductsResponse;
  ProductsResponse selectProductsResponse;
  List<ApparelProductModel> products;
  List<ApparelProductModel> selectProducts;
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
    selectProducts = List<ApparelProductModel>();
    currentProduct = ApparelProductModel.empty();
    productsResponse = ProductsResponse(0, 10, 0, 0, []);
    searchProductsResponse = ProductsResponse(0, 10, 0, 0, []);
    selectProductsResponse = ProductsResponse(0, 10, 0, 0, []);

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

  //产品管理列表
  var _controller = StreamController<PageEntry>.broadcast();
  //产品管理搜素列表
  var _searchController = StreamController<PageEntry>.broadcast();
  //选择产品列表
  var _selectSearchController = StreamController<PageEntry>.broadcast();

  var _detailController = StreamController<ApparelProductModel>();

  Stream<PageEntry> get stream => _controller.stream;
  Stream<PageEntry> get searchStream => _searchController.stream;
  Stream<PageEntry> get selectSearchStream => _selectSearchController.stream;

  Stream<ApparelProductModel> get detailStream => _detailController.stream;
//
  //搜索
  getSearchData(String keyword,{String status}) async {
    if (!lock) {
      print(keyword);
      lock = true;
      products.clear();
      searchProductsResponse = await ProductRepositoryImpl().list({'keyword': keyword,'approvalStatuses': status,}, {});
      if(searchProductsResponse != null){
        products.addAll(searchProductsResponse.content);
      }

      _searchController.sink.add(PageEntry(data: products));
      lock = false;
    }
  }

  //加载更多
  loadingMoreSearchData(String keyword,{String status}) async {
    if (searchProductsResponse.number < searchProductsResponse.totalPages - 1) {
      searchProductsResponse = await ProductRepositoryImpl().list({
        'keyword': keyword,
        'approvalStatuses': status,
      }, {
        'page': searchProductsResponse.number + 1,
      });
      products.addAll(searchProductsResponse.content);
    } else {
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _searchController.sink.add(PageEntry(data: products));
  }

  //选择
  getSelectData(String keyword,{String status}) async {
    if (!lock) {
      print(keyword);
      lock = true;
      selectProducts.clear();
      selectProductsResponse = await ProductRepositoryImpl().list({'keyword': keyword,'approvalStatuses': status,}, {});
      if(selectProductsResponse != null){
        selectProducts.addAll(selectProductsResponse.content);
      }

      _selectSearchController.sink.add(PageEntry(data: selectProducts));
      lock = false;
    }
  }

  //加载更多
  loadingMoreSelectData(String keyword,{String status}) async {
    if (selectProductsResponse.number < selectProductsResponse.totalPages - 1) {
      selectProductsResponse = await ProductRepositoryImpl().list({
        'keyword': keyword,
        'approvalStatuses': status,
      }, {
        'page': selectProductsResponse.number + 1,
      });
      selectProducts.addAll(selectProductsResponse.content);
    } else {
      bottomController.sink.add(true);
    }
    loadingController.sink.add(false);
    _selectSearchController.sink.add(PageEntry(data: selectProducts));
  }

  //产品管理
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

  //加载更多
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

  dispose() {
    _controller.close();
    _searchController.close();
    _selectSearchController.close();
    _detailController.close();

    super.dispose();
  }

  clear() {
    _controller.sink.add(null);
  }

  clearSearchProducts() {
    _searchController.sink.add(null);
  }

  clearSelectSearchProducts() {
    _selectSearchController.sink.add(null);
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
    _controller.sink.add(null);
  }

  deleteProductResetData(String status,String code){
    //删除产品重置数据
    _productsMap[status].data.removeWhere((item) => item.code == code);
    _controller.sink.add(_productsMap[status]);
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

  deleteSearchProductResetData(String status,String code){
    //删除查询产品重置数据
    products.removeWhere((item) => item.code == code);
    _searchController.sink.add(PageEntry(data: products));
  }
}
