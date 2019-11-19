import 'package:b2b_commerce/src/business/orders/form/purchase/ColorSizeEntry.dart';
import 'package:b2b_commerce/src/business/orders/form/purchase/FormMixins.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/ColorSizeTable.dart';

class ReconciliationOrderForm extends StatefulWidget {
  final DeliveryOrderNoteModel deliveryOrder;

  final PurchaseOrderModel purchaseOrder;

  final ReconciliationOrderNoteModel reconciliationOrder;

  final VoidCallback onCallback;

  const ReconciliationOrderForm(
      {Key key,
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
    with SingleTickerProviderStateMixin, DeliverAndShippingFormMixin {
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
    // if (widget.deliveryOrder != null) {
    //   initDeliveryUpdate(widget.deliveryOrder);
    // } else if (widget.shippingOrder != null) {
    //   initDeliveryCreate(widget.shippingOrder);
    // }
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
                      height: 365,
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
    if (widget.deliveryOrder == null) {
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
          TextFieldComponent(
            focusNode: withdrawalQualityFocusNode,
            controller: withdrawalQualityController,
            leadingText: Text('退料',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            hintText: '填写',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: defectiveQualityFocusNode,
            controller: defectiveQualityController,
            leadingText: Text('残次品数',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
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

  ///款项
  Widget _buildMoneySection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            focusNode: consigneeNameFocusNode,
            controller: consigneeNameController,
            leadingText: Text('收货人',
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
            focusNode: consigneePhoneFocusNode,
            controller: consigneePhoneController,
            leadingText: Text('联系方式',
                style: TextStyle(
                  fontSize: 16,
                )),
            inputFormatters: [
              DecimalInputFormat(),
            ],
            hintText: '电话号码',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          TextFieldComponent(
            focusNode: consigneeAddressFocusNode,
            controller: consigneeAddressController,
            leadingText: Text('收货地址',
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
                                  '确认完成收货',
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

  ///保存
  void onSave() {
    // DeliveryOrderNoteModel model;
    // if (widget.deliveryOrder == null) {
    //   model = getDeliveryForCreate(colorSizeEntries);
    // } else {
    //   model = getDeliveryForUpdate(widget.deliveryOrder, colorSizeEntries);
    // }
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) {
    //       return RequestDataLoading(
    //         requestCallBack: widget.deliveryOrder == null
    //             ? DeliveryOrderRepository()
    //                 .createDeliveryOrder(widget.purchaseOrder.code, model)
    //             : DeliveryOrderRepository().updateDeliveryOrder(model),
    //         outsideDismiss: false,
    //         loadingText: '保存中。。。',
    //         entrance: '',
    //       );
    //     }).then((value) {
    //   bool result = false;
    //   if (value != null) {
    //     result = true;
    //   }
    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (_) {
    //         return CustomizeDialog(
    //           dialogType: DialogType.RESULT_DIALOG,
    //           failTips: '保存失败',
    //           successTips: '保存成功',
    //           callbackResult: result,
    //           confirmAction: jumpToDetail,
    //         );
    //       });
    // });
  }

  ///提交收货单
  void onConfirm() {
    // DeliveryOrderNoteModel model;
    // if (widget.deliveryOrder == null) {
    //   model = getDeliveryForCreate(colorSizeEntries);
    // } else {
    //   model = getDeliveryForUpdate(widget.deliveryOrder, colorSizeEntries);
    // }
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) {
    //       return RequestDataLoading(
    //         requestCallBack: widget.deliveryOrder == null
    //             ? DeliveryOrderRepository().createAndCommitDeliveryOrder(
    //                 widget.purchaseOrder.code, model)
    //             : DeliveryOrderRepository().updateAndCommitDeliveryOrder(model),
    //         outsideDismiss: false,
    //         loadingText: '保存中。。。',
    //         entrance: '',
    //       );
    //     }).then((value) {
    //   bool result = false;
    //   if (value != null) {
    //     result = true;
    //   }
    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (_) {
    //         return CustomizeDialog(
    //           dialogType: DialogType.RESULT_DIALOG,
    //           failTips: '保存失败',
    //           successTips: '保存成功',
    //           callbackResult: result,
    //           confirmAction: jumpToDetail,
    //         );
    //       });
    // });
  }

  ///撤回
  void onRecall() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: DeliveryOrderRepository()
                .recallDelivery(widget.deliveryOrder.code),
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
    if (widget.deliveryOrder == null) {
      return true;
    } else {
      if (widget.deliveryOrder.status == OrderNoteStatus.UNCOMMITTED ||
          widget.deliveryOrder.status == OrderNoteStatus.REJECTED) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool showConfirmBtn() {
    if (widget.purchaseOrder.status != PurchaseOrderStatus.OUT_OF_STORE) {
      return false;
    } else if (widget.deliveryOrder == null) {
      return true;
    } else {
      if (widget.deliveryOrder.status == OrderNoteStatus.UNCOMMITTED) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool showRecallBtn() {
    if (widget.deliveryOrder != null &&
        widget.deliveryOrder.status == OrderNoteStatus.PENDING_CONFIRM) {
      return true;
    } else {
      return false;
    }
  }

  void jumpToDetail() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                PurchaseOrderDetailPage(code: widget.purchaseOrder.code)),
        ModalRoute.withName('/'));
  }
}
