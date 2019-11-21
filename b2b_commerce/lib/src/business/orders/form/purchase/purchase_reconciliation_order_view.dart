import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

import '../../purchase_order_detail.dart';
import 'components/ColorSizeView.dart';

class ReconciliationOrderView extends StatefulWidget {
  final ReconciliationOrderNoteModel reconciliationOrder;

  final PurchaseOrderModel purchaseOrder;

  const ReconciliationOrderView(
      {Key key, this.reconciliationOrder, this.purchaseOrder})
      : super(key: key);

  @override
  _ReconciliationOrderViewState createState() =>
      _ReconciliationOrderViewState();
}

class _ReconciliationOrderViewState extends State<ReconciliationOrderView>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = <Widget>[
    Tab(
      text: '对账单信息',
    ),
    Tab(
      text: '款项',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              title: Text(
                '对账单',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: tabs,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
            body: widget.reconciliationOrder != null
                ? Container(
                    color: Colors.white,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            height: 650,
                            child: TabBarView(
                              children: <Widget>[
                                _buildDetailSection(widget.reconciliationOrder),
                                _buildMoneySection(widget.reconciliationOrder),
                              ],
                            )),
                        ColorSizeView(
                          entries: widget.reconciliationOrder.entries,
                        ),
                        _buildBottomSheet()
                      ],
                    ))
                : Center(
              child: Text('暂无对账单'),
                  )));
  }

  ///款项
  Widget _buildMoneySection(ReconciliationOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '延期扣款',
            value: Row(
              children: <Widget>[
                Text(
                  '-',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text('${order.delayDeduction}')
              ],
            ),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.delayDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '质量扣款',
            value: Row(
              children: <Widget>[
                Text(
                  '-',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Text('${order.qualityDeduction}')
              ],
            ),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.qualityDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
              hasBottomBorder: true,
              label: '其他扣款',
              value: Row(
                children: <Widget>[
                  Text(
                    '-',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${order.otherDeduction}'),
                ],
              )),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '扣款备注',
            value: Text('${order.otherDeductionRemarks}'),
          ),
          ItemDivider(),
          B2BInfoRow(
              hasBottomBorder: true,
              label: '其他增款',
              value: Row(
                children: <Widget>[
                  Text(
                    '+',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('${order.otherFunds}'),
                ],
              )),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '备注',
            value: Text('${order.otherFundsRemarks}'),
          ),
        ],
      ),
    );
  }

  ///对账单信息
  Widget _buildDetailSection(ReconciliationOrderNoteModel order) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          B2BInfoRow(
            hasBottomBorder: true,
            label: '甲方',
            value: Text('${order.partA}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '乙方',
            value: Text('${order.partB}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '品牌',
            value: Text('${order.brand ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '款号',
            value: Text('${order.skuID ?? ''}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '加工方式',
            value:
                Text('${CooperationModeLocalizedMap[order.cooperationMethod]}'),
          ),
          ItemDivider(),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '数量合计',
            value: Text('${totalAmount()}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '金额合计',
            value: Text(
                '￥${widget.purchaseOrder.unitPrice}X${totalAmount()}=￥${widget
                    .purchaseOrder.unitPrice * totalAmount()}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '实际应付总额',
            value: Text('￥${shouldPay()}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '已付',
            value: Text('￥${widget.purchaseOrder.payPlan.paidAmount}'),
          ),
          B2BInfoRow(
            hasBottomBorder: true,
            label: '剩余应付金额	',
            value: Text(
                '￥${shouldPay() - widget.purchaseOrder.payPlan.paidAmount}'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      height: 55,
      color: Colors.white,
      margin: EdgeInsets.only(top: 150.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: UserBLoC.instance.currentUser.type == UserType.FACTORY
            ? _buildDeliverConfirmAndRejectBtns()
            : [],
      ),
    );
  }

  List<Widget> _buildDeliverConfirmAndRejectBtns() {
    if (widget.reconciliationOrder != null &&
        widget.reconciliationOrder.status == OrderNoteStatus.PENDING_CONFIRM &&
        UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      return <Widget>[
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      onPressed: rejectReconciliationOrder,
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '拒绝',
                        style: TextStyle(fontSize: 15, color: Colors.red),
                      ),
                    ),
              )),
        ),
        Expanded(
          flex: 1,
          child: Container(
              height: double.infinity,
              child: Builder(
                builder: (BuildContext buttonContext) =>
                    FlatButton(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      onPressed: onReconciliationConfirm,
                      disabledColor: Colors.grey[300],
                      child: Text(
                        '确认',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
              )),
        ),
      ];
    } else {
      return [];
    }
  }

  ///确认对账单
  void onReconciliationConfirm() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ReconciliationOrderRepository()
                .confirmReconciliation(widget.reconciliationOrder.code),
            outsideDismiss: false,
            loadingText: '确认中。。。',
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
              failTips: '确认失败',
              successTips: '确认成功',
              callbackResult: result,
              confirmAction: jumpToDetail,
            );
          });
    });
  }

  ///拒绝对账单
  void rejectReconciliationOrder() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ReconciliationOrderRepository()
                .rejectReconciliation(widget.reconciliationOrder.code),
            outsideDismiss: false,
            loadingText: '拒绝中。。。',
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
              failTips: '拒绝失败',
              successTips: '拒绝成功',
              callbackResult: result,
              confirmAction: jumpToDetail,
            );
          });
    });
  }

  void jumpToDetail() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                PurchaseOrderDetailPage(code: widget.purchaseOrder.code)),
        ModalRoute.withName('/'));
  }

  ///总数
  int totalAmount() {
    int result = 0;
    widget.reconciliationOrder.entries.forEach((entry) {
      result += entry.quantity;
    });
    return result;
  }

  ///应付
  double shouldPay() {
    return totalAmount() * widget.purchaseOrder.unitPrice -
        widget.reconciliationOrder.delayDeduction -
        widget.reconciliationOrder.qualityDeduction -
        widget.reconciliationOrder.otherDeduction +
        widget.reconciliationOrder.otherFunds;
  }
}

class ItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 10, color: Colors.grey[50]);
  }
}
