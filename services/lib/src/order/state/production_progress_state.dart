import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/src/order/repository/purchase_order_repository.dart';

///生产进度状态管理
class ProductionProgressState with ChangeNotifier {
  ///生产单状态
  PurchaseOrderModel _order;

  ///选中生产节点
  ProductionProgressModel _progress;

  PurchaseOrderModel get order => _order;

  ProductionProgressModel get progress => _progress;

  void setOrder(PurchaseOrderModel model) {
    _order = model;

    ///通知刷新
    notifyListeners();
  }

  void setProgress(ProductionProgressModel model) {
    _progress = model;

    ///通知刷新
    notifyListeners();
  }

  void jumpToProgressDetail({BuildContext context,
    MaterialPageRoute materialPageRoute,
    ProductionProgressModel progress,
    VoidCallback callBack}) async {
    ///比较数据时间
    ProductionProgressModel currentProgress = _order.progresses.firstWhere(
            (innerProgress) => innerProgress.id == progress.id,
        orElse: () => null);

    //更新当前选中生产节点
    _progress = progress;
    if (currentProgress != null) {
      if (currentProgress.modifiedtime.compareTo(progress.modifiedtime) > 0) {
        _progress = currentProgress;
      } else {
        _progress = progress;
      }
    } else {
      _progress = progress;
    }

    await Navigator.of(context).push(materialPageRoute);
    if (callBack != null &&
        progress.modifiedtime.compareTo(_progress.modifiedtime) < 0) {
      callBack();
    }
  }

  Future<PurchaseOrderModel> refreshPurchaseOrder() async {
    if (_order != null) {
      //更新生产单
      PurchaseOrderModel model =
      await PurchaseOrderRepository().getPurchaseOrderDetail(_order.code);
      _order = model;
      //更新当前节点
      _progress = _order.progresses.firstWhere(
              (progress) => progress.id == _progress.id,
          orElse: () => _progress);

      ///通知刷新
      notifyListeners();
    }
    return _order;
  }
}
