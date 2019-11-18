import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'purchase_deliver_order_form.dart';
import 'purchase_shipping_order_view.dart';

class PurchaseDetailBtnGroup extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseDetailBtnGroup({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _btnGroup(context),
    );
  }

  List<Widget> _btnGroup(BuildContext context) {
    if (order == null) {
      return [];
    }
    if ((order.status == PurchaseOrderStatus.IN_PRODUCTION ||
        order.status == PurchaseOrderStatus.OUT_OF_STORE ||
        order.status == PurchaseOrderStatus.PENDING_PAYMENT ||
        (order.status == PurchaseOrderStatus.COMPLETED &&
            order.deliveryOrders.isNotEmpty &&
            order.deliveryOrders.first.status ==
                OrderNoteStatus.PENDING_CONFIRM))) {
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                DeliverOrderForm(
                                    purchaseOrderCode: order.code,
                                    deliveryOrder: order.deliveryOrders
                                        .isNotEmpty
                                        ? order.deliveryOrders.first
                                        : null,
                                    shippingOrder: order.deliveryOrders
                                        .isNotEmpty
                                        ? null
                                        : (order.shippingOrders.isNotEmpty
                                        ? order.shippingOrders.last
                                        : null),
                                    orderEntries: order.entries,
                                    onCallback: () => jumpToDetail(context))));
                      },
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '收货',
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
