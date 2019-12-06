import 'package:flutter/material.dart';
import 'package:models/models.dart';

///生产进度状态管理
class ProductionProgressState with ChangeNotifier {
  ///生产单状态
  PurchaseOrderModel _order;

  PurchaseOrderModel get order => _order;

  void setOrder(PurchaseOrderModel model) {
    _order = model;

    ///通知刷新
    notifyListeners();
  }
}
