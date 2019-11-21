import 'package:b2b_commerce/src/business/orders/form/purchase/ColorSizeEntry.dart';
import 'package:b2b_commerce/src/business/orders/form/purchase/FormMixins.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'components/ColorSizeTable.dart';

class ShippingOrderForm extends StatefulWidget {
  final PurchaseOrderModel purchaseOrder;

  final VoidCallback onCallback;

  const ShippingOrderForm({
    Key key,
    this.onCallback,
    this.purchaseOrder,
  }) : super(key: key);

  @override
  _ShippingOrderFormState createState() => _ShippingOrderFormState();
}

class _ShippingOrderFormState extends State<ShippingOrderForm>
    with SingleTickerProviderStateMixin, DeliverAndShippingFormMixin {
  List<ColorSizeEntry> colorSizeEntries;

  List<Widget> tabs = <Widget>[
    Tab(
      text: '发货单信息',
    ),
    Tab(
      text: '发货人',
    ),
    Tab(
      text: '收货人',
    )
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
    initShippingCreate(widget.purchaseOrder);
  }

  Future<List<CarrierModel>> _getCarriers() {
    return Provider.of<CarrierState>(context).getCarriers();
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
              '发货单',
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
                          _buildConsignorSection(),
                          _buildConsigneeSection(),
                        ],
                      )),
                  ColorSizeTable(
                    noteEntries: null,
                    orderEntries: widget.purchaseOrder.entries,
                    colorSizeEntries: colorSizeEntries,
                  ),
                  _buildBottomSheet()
                ],
              ))),
    );
  }

  ///发货人
  Widget _buildConsignorSection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TextFieldComponent(
            focusNode: consignorNameFocusNode,
            controller: consignorNameController,
            leadingText: Text('发货人',
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
            focusNode: consignorPhoneFocusNode,
            controller: consignorPhoneController,
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
          isOfflineConsignment
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey[300], width: 0.5))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '发货方式',
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: <Widget>[
                          FutureBuilder<List<CarrierModel>>(
                              future: _getCarriers(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<CarrierModel>> snapshot) {
                                if (snapshot.data != null) {
                                  return PopupMenuButton<CarrierModel>(
                                    onSelected: (val) {
                                      setState(() {
                                        if (consignment?.carrierDetails !=
                                            null) {
                                          consignment.carrierDetails = val;
                                        } else {
                                          consignment = ConsignmentModel();
                                          consignment.carrierDetails = val;
                                        }
                                      });
                                    },
                                    itemBuilder: (BuildContext context) =>
                                        snapshot.data
                                            .map((carrier) =>
                                                PopupMenuItem<CarrierModel>(
                                                  value: carrier,
                                                  child: new Text(carrier.name),
                                                ))
                                            .toList(),
                                    child: Text(
                                      consignment != null
                                          ? '${consignment?.carrierDetails?.name ?? '选择物流公司'}'
                                          : '选择物流公司',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          )
                        ],
                      )
                    ],
                  ),
                ),
          isOfflineConsignment
              ? Container()
              : TextFieldComponent(
                  focusNode: trackingIDFocusNode,
                  controller: trackingIDController,
                  leadingText: Text('发货单号',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  hintText: '请填写',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('是否线下发货'),
                      Text(
                        '选择线下发货可不填方式和单号',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(isOfflineConsignment ? '是' : '否'),
                    Switch(
                      value: isOfflineConsignment,
                      onChanged: (val) {
                        setState(() {
                          isOfflineConsignment = val;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///发货单信息
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

  ///收货人
  Widget _buildConsigneeSection() {
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
        children: UserBLoC.instance.currentUser.type == UserType.FACTORY
            ? <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      child: Builder(
                        builder: (BuildContext buttonContext) => FlatButton(
                          onPressed: () => onSubmit(false),
                          disabledColor: Colors.grey[300],
                          child: Text(
                            '部分发货',
                            style: TextStyle(fontSize: 15, color: Colors.red),
                          ),
                        ),
                      )),
                ),
                widget.purchaseOrder.status ==
                        PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE
                    ? Expanded(
                        flex: 1,
                        child: Container(
                            height: double.infinity,
                            child: Builder(
                              builder: (BuildContext buttonContext) =>
                                  FlatButton(
                                color: Color.fromRGBO(255, 214, 12, 1),
                                onPressed: () => onSubmit(true),
                                disabledColor: Colors.grey[300],
                                child: Text(
                                  '全部发货',
                                  style: TextStyle(fontSize: 15),
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

  ///发货
  void onSubmit(bool isFull) {
    ShippingOrderNoteModel model = getShippingOrder(colorSizeEntries);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: isFull
                ? ShippingOrderRepository()
                    .fullShippingOrder(widget.purchaseOrder.code, model)
                : ShippingOrderRepository()
                    .partShippingOrder(widget.purchaseOrder.code, model),
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

  void jumpToDetail() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                PurchaseOrderDetailPage(code: widget.purchaseOrder.code)),
        ModalRoute.withName('/'));
  }
}
