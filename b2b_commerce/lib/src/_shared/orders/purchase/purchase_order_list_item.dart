import 'dart:async';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_update_deduction_amount_dialog.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_update_total_price_dialog.dart';
import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail_online.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../../business/orders/purchase_order_detail.dart';
import '../../../common/logistics_input_page.dart';
import '../../../common/order_payment.dart';

class PurchaseOrderListItem extends StatefulWidget {
  PurchaseOrderListItem({Key key, this.order, this.isContractSelect: false})
      : super(key: key);

  final PurchaseOrderModel order;
  bool isContractSelect;

  _PurchaseOrderListItemState createState() => _PurchaseOrderListItemState();
}

class _PurchaseOrderListItemState extends State<PurchaseOrderListItem>
    with AutomaticKeepAliveClientMixin {
  static Map<PurchaseOrderStatus, Color> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildContent(context),
            bloc.isBrandUser
                ? _buildBrandButton(context)
                : _buildFactoryButton(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        if (widget.isContractSelect) {
          Navigator.of(context).pop(widget.order);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                widget.order.salesApplication ==
                    SalesApplication.BELOW_THE_LINE
                    ? PurchaseOrderDetailPage(
                  code: widget.order.code,
                )
                    : PurchaseOrderDetailOnlinePage(code: widget.order.code)),
          );
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              (widget.order.salesApplication == SalesApplication.ONLINE &&
                  widget.order.depositPaid == false &&
                  widget.order.deposit != null &&
                  widget.order.deposit != 0 &&
                  widget.order.status ==
                              PurchaseOrderStatus.PENDING_PAYMENT) ||
                  (widget.order.salesApplication ==
                              SalesApplication.ONLINE &&
                      widget.order.balancePaid == false &&
                      widget.order.balance != null &&
                      widget.order.balance != 0 &&
                      widget.order.status ==
                              PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '￥',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.order.salesApplication ==
                              SalesApplication.ONLINE &&
                              widget.order.depositPaid == false &&
                              widget.order.status ==
                                  PurchaseOrderStatus.PENDING_PAYMENT ? widget
                              .order.deposit == null ? 0.0 : widget.order
                              .deposit.toStringAsFixed(2) : widget.order
                              .balance == null ? 0.0 : (widget.order.balance +
                              (widget.order.deductionAmount ?? 0))
                              .toStringAsFixed(2)}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildHeaderText(context),
                      ],
                    )
                  : Container(
                  child: widget.order.delayedDays != null &&
                      widget.order.delayedDays > 0
                          ? Text('已延期',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ))
                          : Container()),
              widget.order.status == null
                  ? Container()
                  : Expanded(
                      flex: 3,
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${PurchaseOrderStatusLocalizedMap[widget.order
                                .status]}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                              color: _statusColors[widget.order.status],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: UserBLoC.instance.currentUser.type == UserType.BRAND
                      ? Text(
                    '${widget.order.belongTo == null ? widget.order
                        .companyOfSeller != null
                        ? widget.order.companyOfSeller
                        : '' : widget.order.belongTo.name}',
                    style: const TextStyle(fontSize: 16),
                  )
                      : Text(
                    '${widget.order.purchaser == null ? widget.order
                        .companyOfSeller != null
                        ? widget.order.companyOfSeller
                        : '' : widget.order.purchaser.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                '${widget.order.salesApplication == null
                    ? ''
                    : SalesApplicationLocalizedMap[widget.order
                    .salesApplication]}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.depositPaid == false &&
        (widget.order.deposit != null || widget.order.deposit > 0) &&
        widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付定金',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.balancePaid == false &&
        (widget.order.balance != null || widget.order.balance > 0) &&
        widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付尾款',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    widget.order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(widget.order.product?.thumbnail),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: widget.order.product == null ||
                            widget.order.product.name == null
                            ? Container()
                            : Text(
                          '${widget.order.product.name}',
                          overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：${widget.order.product == null ||
                                widget.order.product.skuID == null ? '' : widget
                                .order.product.skuID}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      widget.order.product == null ||
                          widget.order.product.category == null
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 243, 243, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${widget.order?.product?.category?.name ??
                                    ''}  $sum件",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromRGBO(255, 133, 148, 1),
                                ),
                              ),
                            )
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildBrandButton(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE) {
      if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
        if (widget.order.depositPaid == false &&
            widget.order.deposit != null &&
            widget.order.deposit > 0) {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 40),
                      child: widget.order.status ==
                          PurchaseOrderStatus.PENDING_PAYMENT
                          ? FlatButton(
                          color: Colors.red,
                          child: Text(
                            '取消订单',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          onPressed: () async {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return CustomizeDialog(
                                    dialogType: DialogType.CONFIRM_DIALOG,
                                    contentText2: '是否取消订单？',
                                    contentTextStyle2:
                                    TextStyle(color: Colors.black),
                                    isNeedConfirmButton: true,
                                    isNeedCancelButton: true,
                                    confirmAction: () {
                                      Navigator.of(context).pop();
                                      cancelOrder(widget.order.code);
                                    },
                                  );
                                });
                          })
                          : Container()),
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 40),
                      height: 30,
                      child: FlatButton(
                          color: Color(0xFFFFD600),
                          child: Text(
                            '去支付',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          onPressed: () {
//                            PurchaseOrderModel order = widget.order;
                            //将支付金额置为定金
//                            order.totalPrice = order.deposit;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => OrderPaymentPage(
                                  order: widget.order,
                                  paymentFor: PaymentFor.DEPOSIT,
                                )));
                          })),
                ),
              ],
            ),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  height: 30,
                  child: FlatButton(
                      color: Colors.red,
                      child: Text(
                        '取消订单',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
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
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) {
                                          return RequestDataLoading(
                                            requestCallBack:
                                            PurchaseOrderRepository()
                                                .purchaseOrderCancelling(
                                                widget.order.code),
                                            outsideDismiss: false,
                                            loadingText: '正在取消。。。',
                                            entrance: 'purchaseOrders',
                                          );
                                        });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                ),
              ),
              Expanded(
                child: Container(
                    height: 30,
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                    child: FlatButton(
                        color: Color(0xFFFFD600),
                        child: Text(
                          '确认',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return RequestDataLoading(
                                  requestCallBack: PurchaseOrderRepository()
                                      .confirmProduction(
                                      widget.order.code, widget.order),
                                  outsideDismiss: false,
                                  loadingText: '保存中。。。',
                                  entrance: 'purchaseOrders',
                                );
                              });
                        })),
              ),
            ],
          );
        }
      }
      //支付尾款
      else if (widget.order.status ==
          PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
        if (widget.order.balancePaid == false &&
            widget.order.balance != null &&
            widget.order.balance > 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Container(
                    height: 30,
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                    child: FlatButton(
                        color: Color(0xFFFFD600),
                        child: Text(
                          '去支付',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        onPressed: () async {
                          PurchaseOrderModel order = widget.order;
                          //将支付金额置为定金
//                          order.totalPrice = order.balance;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OrderPaymentPage(
                                order: widget.order,
                                paymentFor: PaymentFor.BALANCE,
                              )));
                        })),
              ),
            ],
          );
        }
      }
      // //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确认收货',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return RequestDataLoading(
                                requestCallBack: PurchaseOrderRepository()
                                    .purchaseOrderShipped(
                                    widget.order.code, widget.order),
                                outsideDismiss: false,
                                loadingText: '保存中。。。',
                                entrance: 'purchaseOrders',
                              );
                            });
                      })),
            ),
          ],
        );
      }
    } else {
      //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                  height: 30,
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确认收货',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) {
                              return RequestDataLoading(
                                requestCallBack: PurchaseOrderRepository()
                                    .purchaseOrderShipped(
                                    widget.order.code, widget.order),
                                outsideDismiss: false,
                                loadingText: '保存中。。。',
                                entrance: 'purchaseOrders',
                              );
                            });
                      })),
            ),
          ],
        );
      }
    }
    return Container();
  }

  Widget _buildFactoryButton(BuildContext context) {
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT &&
        widget.order.depositPaid == false) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Expanded(
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
              child: FlatButton(
                  color: Colors.red,
                  child: const Text(
                    '修改价格',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return PurchaseUpdateTotalPriceDialog(
                            purchaseOrderModel: widget.order,
                          );
                        }).then((value) {
                      if (value != null && value != '') {
                        String str = value;
                        str = str.replaceAll('￥', '');
                        print(str);
                        String deposit = str.substring(0, str.indexOf(','));
                        String date =
                        str.substring(str.indexOf(',') + 1, str.length);
                        _showDepositDialog(context, widget.order, deposit,
                            date == 'null' ? null : DateTime.parse(date));
                      }
                    });
                  }),
            ),
          ),
        ],
      );
    }
    //流程是生产中时，显示验货完成按钮
//   else if(order.status == PurchaseOrderStatus.IN_PRODUCTION && order.currentPhase == ProductionProgressPhase.INSPECTION){
//       return Container(
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             padding: EdgeInsets.only(right: 30),
//             width: 150,
//             child: FlatButton(
//                 color: Color(0xFFFFD600),
//                 child: Text(
//                   '验货完成',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.all(Radius.circular(20))),
//                 onPressed: () {
//                   _showBalanceDialog(context, order);
//                 }
//             ),
//           ),
//         )
//     );
//   }
    //当流程是待出库状态下

    else if (widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (widget.order.balancePaid ||
          widget.order.balance == 0 ||
          widget.order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                height: 30,
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '确认发货',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LogisticsInputPage(
                            isProductionOrder: true,
                            purchaseOrderModel: widget.order),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      } else if (widget.order.salesApplication == SalesApplication.ONLINE &&
          !widget.order.balancePaid) {
        //未付尾款时可以修改金额
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(
                height: 30,
                padding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                child: FlatButton(
                  color: Colors.red,
                  child: const Text(
                    '修改价格',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  onPressed: () async {
                    _showBalanceDialog(context, widget.order);
                  },
                ),
              ),
            ),
          ],
        );
      }
    }
    //当流程是已出库时，可以查看物流
    else if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return Container(
//          child: Align(
//            alignment: Alignment.bottomRight,
//            child: Container(
//              padding: EdgeInsets.only(right: 30),
//              width: 150,
//              child: FlatButton(
//                  color: Color(0xFFFFD600),
//                  child: Text(
//                    '查看物流',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 18,
//                    ),
//                  ),
//                  shape: RoundedRectangleBorder(
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(20))),
//                  onPressed: () {
//                    //todo 接通查看物流信息页面
//                  }
//              ),
//            ),
//          )
          );
    }

    return Container();
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context, PurchaseOrderModel model) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return PurchaseUpdateDeductionAmountDialog(
            purchaseOrderModel: model,
          );
        }).then((value) {
      if (value != null && value != '') {
        String str = value;
        _updateBalance(context, model, str);
      }
    });
  }

  void _updateBalance(BuildContext context, PurchaseOrderModel model,
      String text) async {
    double amount = double.parse(text);

    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderDeductionAmountUpdate(
                  model.code, PurchaseOrderModel(deductionAmount: amount)),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'purchaseOrders',
            );
          }).then((value) async {
        if (value) {
          PurchaseOrderModel purchaseOrderModel =
          await PurchaseOrderRepository()
              .getPurchaseOrderDetail(model.code);
          setState(() {
            PurchaseOrderBLoC.instance
                .updateAmountResetData('ALL', purchaseOrderModel);
            PurchaseOrderBLoC.instance.updateAmountResetData(
                'WAIT_FOR_OUT_OF_STORE', purchaseOrderModel);
            BotToast.showText(text: '修改价格成功');
          });
        } else {
          BotToast.showText(text: '修改价格失败');
        }
      });
    } catch (e) {
      print(e);
    }
  }

  //打开修改定金金额弹框
  void _showDepositDialog(BuildContext context, PurchaseOrderModel model,
      String depositText, DateTime date) {
    double totalPrice = 0.0;
    if (depositText != null && depositText != '') {
      if (depositText.indexOf('￥') != 0) {
        totalPrice = double.parse(depositText.replaceAll('￥', ''));
      }
    }

    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderDepositUpdate(
                  model.code,
                  PurchaseOrderModel(
                      totalPrice: totalPrice, expectedDeliveryDate: date)),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: '0',
            );
          }).then((value) async {
        if (value) {
          PurchaseOrderModel purchaseOrderModel =
          await PurchaseOrderRepository()
              .getPurchaseOrderDetail(model.code);
          setState(() {
            PurchaseOrderBLoC.instance
                .updateAmountResetData('ALL', purchaseOrderModel);
            PurchaseOrderBLoC.instance
                .updateAmountResetData('PENDING_PAYMENT', purchaseOrderModel);
            BotToast.showText(text: '修改价格成功');
          });
        } else {
          BotToast.showText(text: '修改价格失败');
        }
      });
    } catch (e) {
      print(e);
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
              _neverComplete(context, widget.order);
            },
          );
        });
  }

  //确认跳过按钮
  Future<void> _neverComplete(BuildContext context,
      PurchaseOrderModel model) async {
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
              entrance: '',
            );
          }).then((value) {
        if (value) {
          BotToast.showText(text: '跳过尾款成功');
          PurchaseOrderBLoC.instance.refreshData('ALL');
          PurchaseOrderBLoC.instance.refreshData('WAIT_FOR_OUT_OF_STORE');
          PurchaseOrderBLoC.instance.refreshData('OUT_OF_STORE');
        }
      });
      if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
        try {
          for (int i = 0; i < widget.order.progresses.length; i++) {
            if (widget.order.currentPhase == widget.order.progresses[i].phase) {
              await PurchaseOrderRepository().productionProgressUpload(
                  widget.order.code,
                  widget.order.progresses[i].id.toString(),
                  widget.order.progresses[i]);
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

  void _showMessage(BuildContext context, bool result, String message) {
    _requestMessage(context, result ? '$message成功' : '$message失败');
    PurchaseOrderBLoC.instance.refreshData('ALL');
  }

  void cancelOrder(String code) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().purchaseOrderCancelling(code),
            outsideDismiss: false,
            loadingText: '正在取消。。。',
            entrance: 'purchaseOrders',
          );
        });
    BotToast.showLoading(
        duration: Duration(milliseconds: 500), clickClose: true);

    ///刷新全部-状态
    PurchaseOrderBLoC.instance.refreshData('ALL');

    ///刷新待付款-状态(只有待付款订单才能取消)
    PurchaseOrderBLoC.instance.refreshData('PENDING_PAYMENT');
  }

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          children: <Widget>[SimpleDialogOption(child: Text('$message'))],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
