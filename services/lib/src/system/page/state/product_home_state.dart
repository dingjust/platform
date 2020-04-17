import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/src/system/page/repository/product_page_respository.dart';

///板块首页状态管理
class ProductHomeState with ChangeNotifier {
  List<PlateItem> _items;

  PlateItem getItem(SeeProductPlateType type) {
    if (_items == null) {
      getData();
      return null;
    } else {
      return _items.firstWhere((item) => item.type == type, orElse: () => null);
    }
  }

  void getData() async {
    await ProductPageRepository().productHomePlateItems().then((response) {
      if (response != null) {
        _items = response;

        ///通知刷新
        notifyListeners();
      }
    });
  }
}
