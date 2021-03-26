import 'package:models/models.dart';
import 'package:services/src/product/repository/materiel_product_respository.dart';
import 'package:services/src/state/state.dart';

import '../../../services.dart';

///面辅料状态管理
class MaterielProductState extends PageState {
  ///是否全部面辅料，true为全部在售,false为自己
  final bool isAll;

  List<MaterielProductModel> _products;

  MaterielProductState({this.isAll = false});

  List<MaterielProductModel> get products {
    if (_products == null) {
      getData();
    }
    return _products;
  }

  @override
  getData() {
    MaterielProductRepository.getProducts(
            isAll
                ? ProductApis.materielProductAll
                : ProductApis.materielProductSearch,
            params: {'page': 0, 'size': pageSize},
            data: getParamsData())
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
        await MaterielProductRepository.getProducts(
                isAll
                    ? ProductApis.materielProductAll
                    : ProductApis.materielProductSearch,
                params: {
                  'page': ++currentPage,
                  'size': pageSize,
                },
                data: getParamsData())
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
    return {};
  }

  @override
  clear() {
    _products = null;
    reset();
    notifyListeners();
  }
}
