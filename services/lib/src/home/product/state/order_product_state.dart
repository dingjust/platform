import 'package:models/models.dart';
import 'package:services/src/home/product/respository/order_product_respository.dart';
import 'package:services/src/state/state.dart';

///看款状态管理
class ProductState extends PageState {
  List<ApparelProductModel> _products;

  List<ApparelProductModel> get products {
    if (_products == null) {
      getData();
    }
    return _products;
  }

  @override
  getData() {
    OrderProductRepository.getProducts(
            params: {'page': 0, 'size': pageSize}, data: getParamsData())
        .then((response) {
      if (response != null) {
        _products = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;

        ///通知刷新
        notifyListeners();
      }
    });
  }

  @override
  loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await OrderProductRepository.getProducts(params: {
          'page': ++currentPage,
          'size': pageSize,
        }, data: getParamsData())
            .then((response) {
          if (response != null) {
            _products.addAll(response.content);
            pageSize = response.size;
            currentPage = response.number;
            totalPages = response.totalPages;
            totalElements = response.totalElements;
          }
        });
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  ///请求参数
  Map<String, dynamic> getParamsData() {
    return {
      'approvalStatuses': ["approved"]
    };
  }

  @override
  clear() {
    _products = null;
    reset();
    notifyListeners();
  }
}
