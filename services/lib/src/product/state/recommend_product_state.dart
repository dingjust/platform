import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:flutter/material.dart';

///板块产品状态管理
class RecommendProductState with ChangeNotifier {
  List<ApparelProductModel> _products;

  List<ApparelProductModel> get products {
    if (_products == null) {
      _getRecommendProducts();
    }
    return _products;
  }

  ///获取推荐产品
  Future<void> _getRecommendProducts() async {
    await ProductRepositoryImpl().getProductsOfFactories({
      'plateType':
          SeeProductPlateTypeValuedMap[SeeProductPlateType.RECOMMEND_FOR_YOU]
    }, {
      'page': 0,
      'size': 30,
    }).then((response) {
      if (response != null) {
        _products = response.content;
        notifyListeners();
      }
    });
  }

  void clear() {
    _products = null;
    notifyListeners();
  }
}
