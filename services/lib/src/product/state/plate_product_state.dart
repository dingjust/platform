import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/state/state.dart';

///板块产品状态管理
class PlateProductState extends PageState {
  final SeeProductPlateType type;

  List<ApparelProductModel> _products;

  ///推荐产品
  List<ApparelProductModel> recommendProducts;

  ProductCondition condition;

  final bool showRecommendProducts;

  PlateProductState(
      {this.type, this.condition, this.showRecommendProducts = true}) {
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

        //无产品，显示推荐产品
        if (totalElements == 0 || currentPage + 1 == totalPages) {
          _getRecommendProducts();
        }

        ///通知刷新
        notifyListeners();
      }
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
      } else if (showRecommendProducts && recommendProducts == null) {
        //产品结束，显示推荐产品
        await _getRecommendProducts();
      }
      //异步调用结束，通知加载组件
      workingEnd();
    }
  }

  ///获取推荐产品
  Future<void> _getRecommendProducts() async {
    await ProductRepositoryImpl().getProductsOfFactories({
      'plateType':
      SeeProductPlateTypeValuedMap[SeeProductPlateType.RECOMMEND_FOR_YOU]
    }, {
      'page': 0,
      'size': 20,
    }).then((response) {
      if (response != null) {
        recommendProducts = response.content;
        notifyListeners();
      }
    });
  }

  Map<String, dynamic> generateFilterCondition() {
    Map<String, dynamic> filterCondition = condition.toDataJson();
    filterCondition['approvalStatuses'] = ['approved'];

    if (type != null) {
      filterCondition['plateType'] = SeeProductPlateTypeValuedMap[type];
    }

    return filterCondition;
  }

  @override
  void clear() {
    _products = null;
    reset();
    notifyListeners();
  }
}
