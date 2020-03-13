import 'package:b2b_commerce/src/business/orders/form/purchase/purchase_deliver_order_view.dart';
import 'package:b2b_commerce/src/business/orders/form/purchase/purchase_reconciliation_order_form.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/common/logistics_input_page.dart';
import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'purchase_deliver_order_form.dart';
import 'purchase_reconciliation_order_view.dart';
import 'purchase_shipping_order_view.dart';

class PurchaseDetailOnlineBtnGroup extends StatelessWidget {
  final PurchaseOrderModel order;
  final VoidCallback onUpdateDeposit;
  final VoidCallback onUpdateBalance;

  const PurchaseDetailOnlineBtnGroup({Key key, this.order,this.onUpdateDeposit,this.onUpdateBalance,}) : super(key: key);

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
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
        order.depositPaid == false) {
      return [
        Expanded(flex: 1, child: Container()),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) => FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () => onUpdateDeposit(),
                  disabledColor: Colors.grey[300],
                  child: Text(
                    '修改价格',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )),
        )
      ];
    } //当流程是待出库状态下
    else if (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (order.balancePaid ||
          order.balance == 0 ||
          order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return [
          Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LogisticsInputPage(
                          isProductionOrder: true, purchaseOrderModel: order),
                    ),
                  );
                },
                child: Text(
                  '确认发货',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              )),
        ];
      } else if (order.salesApplication == SalesApplication.ONLINE &&
          !order.balancePaid) {
        //未付尾款时可以修改金额
        return [
          Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () => onUpdateBalance(),
                child: Text(
                  '修改金额',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              )),
        ];
      }
    } else {
      return [];
    }
  }

  List<Widget> _brandBtnGroup(BuildContext context) {
    if (order == null) {
      return [];
    }
    if (order.depositPaid == false &&
        order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
      return [
        Expanded(
            flex: 1,
            child: FlatButton(
              onPressed: () => _onOnlineCancel(context),
              child: Text(
                '取消订单',
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            )),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) => FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () {
                    //将支付金额置为定金
                    order.totalPrice = order.deposit;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderPaymentPage(
                              order: order,
                              paymentFor: PaymentFor.DEPOSIT,
                            )));
                  },
                  disabledColor: Colors.grey[300],
                  child: Text(
                    '去支付',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )),
        )
      ];
    } else if (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE &&
        order.balancePaid == false &&
        order.balance != null &&
        order.balance > 0) {
      return [
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) => FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () async {
                    //将支付金额置为尾款
                    order.totalPrice = order.balance;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            OrderPaymentPage(
                              order: order,
                              paymentFor: PaymentFor.BALANCE,
                            )));
                  },
                  disabledColor: Colors.grey[300],
                  child: Text(
                    '去支付',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              )),
        )
      ];
    } else if (order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) => FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () async {
                    bool result = false;
                    result = await PurchaseOrderRepository()
                        .purchaseOrderShipped(order.code, order);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return CustomizeDialog(
                            dialogType: DialogType.RESULT_DIALOG,
                            successTips: '确认收货成功',
                            failTips: '确认收货失败',
                            callbackResult: result,
                          );
                        });
                  },
                  disabledColor: Colors.grey[300],
                  child: Text(
                    '确认收货',
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

  Future<void> _showTips(BuildContext context, PurchaseOrderModel model) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否无需付款直接跳过？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              _neverComplete(context, order);
            },
          );
        });
  }

  //确认跳过按钮
  Future<void> _neverComplete(
      BuildContext context, PurchaseOrderModel model) async {
    model.balance = 0;
    model.skipPayBalance = true;
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderBalanceUpdate(model.code, model),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'purchaseOrders',
            );
          });
      if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
        try {
          for (int i = 0; i < order.progresses.length; i++) {
            if (order.currentPhase == order.progresses[i].phase) {
              await PurchaseOrderRepository().productionProgressUpload(
                  order.code,
                  order.progresses[i].id.toString(),
                  order.progresses[i]);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void onShippingOrders(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingOrderView(
          shippingOrders: order.shippingOrders,
        ),
      ),
    );
  }

  void onDeliverOrder(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliverOrderView(
          purchaseOrderCode: order.code,
          deliveryOrder:
              order.deliveryOrders.isNotEmpty ? order.deliveryOrders[0] : null,
        ),
      ),
    );
  }

  void onDeliverForm(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeliverOrderForm(
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
        builder: (context) => ReconciliationOrderView(
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
        builder: (context) => ReconciliationOrderForm(
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

  void _onOnlineCancel(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(
            '提示',
            style: const TextStyle(fontSize: 16),
          ),
          content: Text('是否要取消订单？'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return RequestDataLoading(
                        requestCallBack: PurchaseOrderRepository()
                            .purchaseOrderCancelling(order.code),
                        outsideDismiss: false,
                        loadingText: '取消中。。。',
                        entrance: 'purchaseOrders',
                      );
                    }).then((val) {
                  PurchaseOrderBLoC.instance.refreshData('ALL');
                });
              },
            ),
          ],
        );
      },
    );
  }
}
