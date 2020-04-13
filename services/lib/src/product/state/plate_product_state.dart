import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///板块产品状态管理
class PlateProductState extends PageState {
  final SeeProductPlateType type;

  List<ApparelProductModel> _products;

  ProductCondition condition;

  PlateProductState({this.type, this.condition}) {
    if (condition != null) {
      condition = condition;
    } else {
      condition = ProductCondition([], '');
    }
  }

  List<ApparelProductModel> get products {
    if (_products == null) {
      getData();
    }
    return _products;
  }

  @override
  void getData() async {
    await ProductRepositoryImpl()
        .getProductsOfFactories(generateFilterCondition(), {
      'page': 0,
      'size': pageSize,
      'sort': condition.sortCondition != null
          ? '${condition.sortCondition},${condition.sort}'
          : ''
    }).then((response) {
      if (response != null) {
        _products = response.content;
        pageSize = response.size;
        currentPage = response.number;
        totalPages = response.totalPages;
        totalElements = response.totalElements;
      }

      ///通知刷新
      notifyListeners();
    });
  }

  @override
  void loadMore() async {
    if (!lock) {
      //异步调用开始，通知加载组件
      workingStart();
      //接口调用：
      if (currentPage + 1 != totalPages) {
        await ProductRepositoryImpl()
            .getProductsOfFactories(generateFilterCondition(), {
          'page': ++currentPage,
          'size': pageSize,
          'sort': condition.sortCondition != null
              ? '${condition.sortCondition},${condition.sort}'
              : ''
        }).then((response) {
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

  Map<String, dynamic> generateFilterCondition() {
    Map<String, dynamic> filterCondition = condition.toDataJson();
    filterCondition['approvalStatuses'] = ['approved'];

    if (type != null) {
      filterCondition['plateType'] = SeeProductPlateTypeValuedMap[type];
    }

    if (type == SeeProductPlateType.TODAY_NEW) {}
    return filterCondition;
  }

  @override
  void clear() {
    _products = null;
    reset();
    notifyListeners();
  }
}
