import 'package:b2b_commerce/src/business/orders/form/purchase/purchase_deliver_order_view.dart';
import 'package:b2b_commerce/src/business/orders/form/purchase/purchase_reconciliation_order_form.dart';
import 'package:b2b_commerce/src/business/orders/form/purchase/purchase_shipping_order_form.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'purchase_deliver_order_form.dart';
import 'purchase_reconciliation_order_view.dart';
import 'purchase_shipping_order_view.dart';

class PurchaseDetailBtnGroup extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseDetailBtnGroup({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: UserBLoC.instance.currentUser.type == UserType.FACTORY
          ? _factoryBtnGroup(context)
          : _brandBtnGroup(context),
    );
  }

  List<Widget> _factoryBtnGroup(BuildContext context) {
    if (order == null) {
      return [];
    }
    if (order.status == PurchaseOrderStatus.IN_PRODUCTION ||
        order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE ||
        order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => onDeliverOrder(context),
              child: Text(
                '查看收货单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        UserBLoC.instance.currentUser.type == UserType.FACTORY
            ? Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () => onShippingForm(context),
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '发货',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
            : Container()
      ];
    } else if (order.status == PurchaseOrderStatus.COMPLETED) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => onReconciliationOrder(context),
              child: Text(
                '查看对账单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
      ];
    } else if (!isMine() &&
        order.status == PurchaseOrderStatus.PENDING_CONFIRM) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => onCancel(context),
              child: Text(
                '拒单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () => onConfirm(context),
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '接单',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
      ];
    } else {
      return [];
    }
  }

  List<Widget> _brandBtnGroup(BuildContext context) {
    if (order == null) {
      return [];
    }
    if ((order.status == PurchaseOrderStatus.IN_PRODUCTION ||
        order.status == PurchaseOrderStatus.OUT_OF_STORE ||
        order.status == PurchaseOrderStatus.PENDING_PAYMENT ||
        order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE)) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => onShippingOrders(context),
              child: Text(
                '查看发货单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () => onDeliverForm(context),
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '收货',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
      ];
    } else if (order.status == PurchaseOrderStatus.COMPLETED) {
      return [
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () => onReconciliationForm(context),
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '对账',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
      ];
    } else if (!isMine() &&
        order.status == PurchaseOrderStatus.PENDING_CONFIRM) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => onCancel(context),
              child: Text(
                '拒单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: () => onConfirm(context),
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '接单',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        )
      ];
    } else {
      return [];
    }
  }

  bool isMine() {
    if (order.creator != null) {
      return order.creator.uid == UserBLoC.instance.currentUser.companyCode;
    } else {
      return false;
    }
  }

  void onShippingForm(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ShippingOrderForm(
                purchaseOrder: order,
                onCallback: () => jumpToDetail(context))));
  }

  void onShippingOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ShippingOrderView(
              shippingOrders: order.shippingOrders,
            ),
      ),
    );
  }

  void onDeliverOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DeliverOrderView(
              purchaseOrderCode: order.code,
              deliveryOrder:
              order.deliveryOrders.isNotEmpty ? order.deliveryOrders[0] : null,
            ),
      ),
    );
  }

  void onDeliverForm(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            DeliverOrderForm(
                purchaseOrder: order,
                deliveryOrder: order.deliveryOrders.isNotEmpty
                    ? order.deliveryOrders.first
                    : null,
                shippingOrder: order.deliveryOrders.isNotEmpty
                    ? null
                    : (order.shippingOrders.isNotEmpty
                    ? order.shippingOrders.last
                    : null),
                onCallback: () => jumpToDetail(context))));
  }

  void onReconciliationOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReconciliationOrderView(
              purchaseOrder: order,
              reconciliationOrder: order.reconciliationOrders.isNotEmpty
                  ? order.reconciliationOrders[0]
                  : null,
            ),
      ),
    );
  }

  void onReconciliationForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ReconciliationOrderForm(
              purchaseOrder: order,
              reconciliationOrder: order.reconciliationOrders.isNotEmpty
                  ? order.reconciliationOrders.first
                  : null,
              deliveryOrder: order.reconciliationOrders.isNotEmpty
                  ? null
                  : (order.deliveryOrders.isNotEmpty
                  ? order.deliveryOrders.first
                  : null),
              onCallback: () => jumpToDetail(context),
            ),
      ),
    );
  }

  void onCancel(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().cancellingOfPurchaseOrder(order.code),
            outsideDismiss: false,
            loadingText: '取消中。。。',
            entrance: '',
          );
        }).then((value) {
      bool result = false;
      if (value != null) {
        result = true;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '拒单失败',
              successTips: '拒单成功',
              callbackResult: result,
              confirmAction: () => jumpToDetail(context),
            );
          });
    });
  }

  void onConfirm(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository()
                .confirmProductionByOffline(order.code),
            outsideDismiss: false,
            loadingText: '接单中。。。',
            entrance: '',
          );
        }).then((value) {
      bool result = false;
      if (value != null) {
        result = true;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '接单失败',
              successTips: '接单成功',
              callbackResult: result,
              confirmAction: () => jumpToDetail(context),
            );
          });
    });
  }

  void jumpToDetail(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => PurchaseOrderDetailPage(code: order.code)),
        ModalRoute.withName('/'));
  }
}
