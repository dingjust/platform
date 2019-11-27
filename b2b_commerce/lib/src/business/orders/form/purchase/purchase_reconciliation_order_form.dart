import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'ColorSizeEntry.dart';
import 'FormMixins.dart';
import 'components/ColorSizeTable.dart';
import 'purchase_reconciliation_order_view.dart';

class ReconciliationOrderForm extends StatefulWidget {
  final DeliveryOrderNoteModel deliveryOrder;

  final PurchaseOrderModel purchaseOrder;

  final ReconciliationOrderNoteModel reconciliationOrder;

  final VoidCallback onCallback;

  const ReconciliationOrderForm({Key key,
    this.deliveryOrder,
    this.onCallback,
    this.reconciliationOrder,
    this.purchaseOrder})
      : super(key: key);

  @override
  _ReconciliationOrderFormState createState() =>
      _ReconciliationOrderFormState();
}

class _ReconciliationOrderFormState extends State<ReconciliationOrderForm>
    with SingleTickerProviderStateMixin, ReconciliationFormMixin {
  List<ColorSizeEntry> colorSizeEntries;

  List<Widget> tabs = <Widget>[
    Tab(
      text: '对账单信息',
    ),
    Tab(
      text: '款项',
    ),
  ];

  @override
  void initState() {
    super.initState();
    colorSizeEntries = [];

    ///初始化表单变量
    initForm();
  }

  @override
  void initForm() {
    super.initForm();
    //更新或创建
    if (widget.reconciliationOrder != null) {
      initReconciliationUpdate(widget.reconciliationOrder);
    } else if (widget.deliveryOrder != null) {
      initReconciliationCreate(widget.purchaseOrder);
    }
  }

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
              '对账单${orderStatus()}',
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
          body: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Container(
                      height: 650,
                      child: TabBarView(
                        children: <Widget>[
                          _buildDetailSection(),
                          _buildMoneySection(),
                        ],
                      )),
                  ColorSizeTable(
                    noteEntries: widget?.deliveryOrder?.entries ?? null,
                    orderEntries: widget.purchaseOrder.entries,
                    colorSizeEntries: colorSizeEntries,
                  ),
                  _buildBottomSheet()
                ],
              ))),
    );
  }

  String orderStatus() {
    if (widget.reconciliationOrder == null) {
      return '';
    } else {
      return '(${OrderNoteStatusLocalizedMap[widget.reconciliationOrder.status]})';
    }
  }

  ///对账单信息
  Widget _buildDetailSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            focusNode: partAFocusNode,
            controller: partAController,
            leadingText: Text('甲方',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: partBFocusNode,
            controller: partBController,
            leadingText: Text('乙方',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: brandFocusNode,
            controller: brandController,
            leadingText: Text('品牌',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: skuIDFocusNode,
            controller: skuIDController,
            leadingText: Text('款号',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          _buildCooperationModeSelect(),
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

  ///款项
  Widget _buildMoneySection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            focusNode: delayDeductionFocusNode,
            controller: delayDeductionController,
            inputType: TextInputType.number,
            leadingText: Text('延期扣款',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: delayDeductionRemarksFocusNode,
            controller: delayDeductionRemarksController,
            leadingText: Text('扣款备注',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          ItemDivider(),
          TextFieldComponent(
            focusNode: qualityDeductionFocusNode,
            controller: qualityDeductionController,
            inputType: TextInputType.number,
            leadingText: Text('质量扣款',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: qualityDeductionRemarksFocusNode,
            controller: qualityDeductionRemarksController,
            inputType: TextInputType.number,
            leadingText: Text('扣款备注',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          ItemDivider(),
          TextFieldComponent(
            focusNode: otherDeductionFocusNode,
            controller: otherDeductionController,
            inputType: TextInputType.number,
            leadingText: Text('其他扣款',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: otherDeductionRemarksFocusNode,
            controller: otherDeductionRemarksController,
            leadingText: Text('扣款备注',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          ItemDivider(),
          TextFieldComponent(
            focusNode: otherFundsFocusNode,
            controller: otherFundsController,
            inputType: TextInputType.number,
            leadingText: Text('其他增款',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: otherFundsRemarksFocusNode,
            controller: otherFundsRemarksController,
            leadingText: Text('备注',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
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
        children: UserBLoC.instance.currentUser.type == UserType.BRAND
            ? <Widget>[
          showSaveBtn()
              ? Expanded(
            flex: 1,
            child: Container(
                height: double.infinity,
                child: Builder(
                  builder: (BuildContext buttonContext) =>
                      FlatButton(
                        onPressed: onSave,
                        disabledColor: Colors.grey[300],
                        child: Text(
                          '保存并退出',
                          style: TextStyle(
                              fontSize: 15, color: Colors.red),
                        ),
                      ),
                )),
          )
              : Container(),
          showConfirmBtn()
              ? Expanded(
            flex: 1,
            child: Container(
                height: double.infinity,
                child: Builder(
                  builder: (BuildContext buttonContext) =>
                      FlatButton(
                        color: Color.fromRGBO(255, 214, 12, 1),
                        onPressed: onConfirm,
                        disabledColor: Colors.grey[300],
                        child: Text(
                          '确认完成对账',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                )),
          )
              : Container(),
          showRecallBtn()
              ? Expanded(
            flex: 1,
            child: Container(
                height: double.infinity,
                child: Builder(
                  builder: (BuildContext buttonContext) =>
                      FlatButton(
                        onPressed: onRecall,
                        disabledColor: Colors.grey[300],
                        child: Text(
                          '撤回',
                          style: TextStyle(
                              fontSize: 15, color: Colors.red),
                        ),
                      ),
                )),
          )
              : Container(),
        ]
            : [],
      ),
    );
  }

  Widget _buildCooperationModeSelect() {
    return Padding(
      padding: EdgeInsets.only(left: 15),
      child: B2BInfoRow(
        hasBottomBorder: true,
        label: '加工方式',
        value: Row(
          children: CooperationMode.values
              .map((value) =>
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: <Widget>[
                    Text('${CooperationModeLocalizedMap[value]}'),
                    Radio(
                      groupValue: cooperationMethod,
                      value: value,
                      onChanged: (val) {
                        setState(() {
                          cooperationMethod = val;
                        });
                      },
                    )
                  ],
                ),
              ))
              .toList(),
        ),
      ),
    );
  }

  ///保存
  void onSave() {
    ReconciliationOrderNoteModel model;

    if (widget.reconciliationOrder == null) {
      model = getReconciliationForCreate(colorSizeEntries);
    } else {
      model = getReconciliationForUpdate(
          widget.reconciliationOrder, colorSizeEntries);
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: widget.reconciliationOrder == null
                ? ReconciliationOrderRepository()
                .createReconciliationOrder(widget.purchaseOrder.code, model)
                : ReconciliationOrderRepository()
                .updateReconciliationOrder(model),
            outsideDismiss: false,
            loadingText: '保存中。。。',
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
              failTips: '保存失败',
              successTips: '保存成功',
              callbackResult: result,
              confirmAction: jumpToDetail,
            );
          });
    });
  }

  ///提交对账单
  void onConfirm() {
    ReconciliationOrderNoteModel model;
    if (widget.reconciliationOrder == null) {
      model = getReconciliationForCreate(colorSizeEntries);
    } else {
      model = getReconciliationForUpdate(
          widget.reconciliationOrder, colorSizeEntries);
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: widget.reconciliationOrder == null
                ? ReconciliationOrderRepository()
                .createAndCommitReconciliationOrder(
                widget.purchaseOrder.code, model)
                : ReconciliationOrderRepository()
                .updateAndCommitReconciliationOrder(model),
            outsideDismiss: false,
            loadingText: '保存中。。。',
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
              failTips: '保存失败',
              successTips: '保存成功',
              callbackResult: result,
              confirmAction: jumpToDetail,
            );
          });
    });
  }

  ///撤回
  void onRecall() {
    ReconciliationOrderNoteModel model = ReconciliationOrderNoteModel();
    model.id = widget.reconciliationOrder.id;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ReconciliationOrderRepository()
                .recallReconciliationOrder(model),
            outsideDismiss: false,
            loadingText: '撤回中。。。',
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
              failTips: '撤回失败',
              successTips: '撤回成功',
              callbackResult: result,
              confirmAction: jumpToDetail,
            );
          });
    });
  }

  bool showSaveBtn() {
    if (widget.reconciliationOrder == null) {
      return true;
    } else {
      if (widget.reconciliationOrder.status == OrderNoteStatus.UNCOMMITTED ||
          widget.reconciliationOrder.status == OrderNoteStatus.REJECTED) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool showConfirmBtn() {
    if (widget.purchaseOrder.status != PurchaseOrderStatus.COMPLETED) {
      return false;
    } else if (widget.reconciliationOrder == null) {
      return true;
    } else {
      if (widget.reconciliationOrder.status == OrderNoteStatus.UNCOMMITTED) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool showRecallBtn() {
    if (widget.reconciliationOrder != null &&
        widget.reconciliationOrder.status == OrderNoteStatus.PENDING_CONFIRM) {
      return true;
    } else {
      return false;
    }
  }

  ///总数
  int totalAmount() {
    int result = 0;
    if (widget.reconciliationOrder != null) {
      widget.reconciliationOrder.entries.forEach((entry) {
        result += entry.quantity;
      });
    }
    return result;
  }

  ///应付
  double shouldPay() {
    return totalAmount() * widget.purchaseOrder.unitPrice -
        getDoubleFromController(delayDeductionController) -
        getDoubleFromController(qualityDeductionController) -
        getDoubleFromController(otherDeductionController) +
        getDoubleFromController(otherFundsController);
  }

  void jumpToDetail() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                PurchaseOrderDetailPage(code: widget.purchaseOrder.code)),
        ModalRoute.withName('/'));
  }
}
