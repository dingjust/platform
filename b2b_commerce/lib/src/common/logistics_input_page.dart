import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class LogisticsInputPage extends StatefulWidget {
  final bool isProductionOrder;

  final PurchaseOrderModel purchaseOrderModel;

  final ProofingModel proofingModel;

  LogisticsInputPage({
    this.isProductionOrder: false,
    this.purchaseOrderModel,
    this.proofingModel,
  });

  _LogisicsInputPageState createState() => _LogisicsInputPageState();
}

class _LogisicsInputPageState extends State<LogisticsInputPage> {
  List<CarrierModel> list = new List();
  FocusNode _orderNumberFocusNode = FocusNode();
  final TextEditingController _orderNumberController = TextEditingController();
  String carrierName;
  String carrierCode;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    Response response;
    try {
      response = await http$.get(OrderApis.getCarriersAll);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      list.addAll(CarrierModel.fromJsonList(response.data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('填写物流信息'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                _buildHead(context),
                _buildButton(context),
              ],
            )));
  }

  Widget _buildHead(BuildContext) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(
                        '${carrierName == null || carrierName == ''
                            ? '选择快递/物流公司'
                            : carrierName}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    child: Icon(Icons.keyboard_arrow_right),
                  )
                ],
              ),
            ),
            onTap: () async {
              if (list != null && list.isNotEmpty) {
                _showLogisticsSelect(list);
              } else {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return CustomizeDialog(
                        dialogType: DialogType.RESULT_DIALOG,
                        failTips: '获取物流公司失败',
                        callbackResult: false,
                        confirmAction: () {
                          Navigator.of(context).pop();
                        },
                      );
                    });
              }
            },
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            child: TextFieldComponent(
              inputType: TextInputType.number,
              textAlign: TextAlign.left,
              focusNode: _orderNumberFocusNode,
              controller: _orderNumberController,
              hintText: '填写快递/物流单号',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          Container(
            width: 300,
            child: FlatButton(
                color: Color(0xFFFFD600),
                child: Text(
                  '确认',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  //把选中的物流公司放到Model
                  CarrierModel carrier = new CarrierModel();
                  carrier.code = carrierCode;
                  carrier.name = carrierName;
                  //把物流信息放到model
                  ConsignmentModel consignment = new ConsignmentModel();
                  consignment.trackingID = _orderNumberController.text;
                  consignment.carrierDetails = carrier;
                  if (_orderNumberController.text != null &&
                      _orderNumberController.text != '' &&
                      carrierCode != null &&
                      carrierCode != '') {
                    //生产单的确认发货
                    if (widget.isProductionOrder &&
                        widget.purchaseOrderModel != null) {
                      savePurchaseOrder(consignment);
                    }
                    //打样单的确认发货
                    else if (!widget.isProductionOrder &&
                        widget.proofingModel != null) {
                      saveProofingOrder(consignment);
                    } else {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return CustomizeDialog(
                              dialogType: DialogType.RESULT_DIALOG,
                              failTips: '请选择物流公司和填写物流单号',
                              callbackResult: false,
                              confirmAction: () {
                                Navigator.of(context).pop();
                              },
                            );
                          });
                    }
                  }
                }),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 300,
            child: FlatButton(
                color: Colors.grey,
                child: Text(
                  '线下物流，不需填写',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () async {
                  bool result = false;
                  if (widget.isProductionOrder) {
                    saveOfflinePurchaseOrder();
                  } else {
                    saveOfflineProofingOrder();
                  }
                }),
          ),
        ],
      ),
    );
  }

  void saveOfflineProofingOrder() {
    widget.proofingModel.isOfflineConsignment = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ProofingOrderRepository().proofingDelivering(
                widget.proofingModel.code, widget.proofingModel),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      bool result = false;
      if (value != null) {
        result = value;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '确认发货成功',
              failTips: '确认发货失败',
              callbackResult: result,
            );
          }).then((val) {
        ProofingOrdersBLoC.instance.refreshData('ALL');
        ProofingOrdersBLoC.instance.refreshData('PENDING_DELIVERY');
        ProofingOrdersBLoC.instance.refreshData('SHIPPED');
        Navigator.pop(context);
      });
    });
  }

  void saveOfflinePurchaseOrder() {
    widget.purchaseOrderModel.isOfflineConsignment = true;
    // widget.purchaseOrderModel.consignment = ConsignmentModel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository().purchaseOrderDelivering(
                widget.purchaseOrderModel.code, widget.purchaseOrderModel),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      bool result = false;
      if (value != null) {
        result = value;
      }
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                successTips: '确认发货成功',
                failTips: '确认发货失败',
                callbackResult: result);
          });
      PurchaseOrderBLoC.instance.refreshData('ALL');
      PurchaseOrderBLoC.instance.refreshData('WAIT_FOR_OUT_OF_STORE');
      PurchaseOrderBLoC.instance.refreshData('OUT_OF_STORE');
      Navigator.of(context).pop();
    });
  }

  void savePurchaseOrder(ConsignmentModel consignment) {
    //把内容放到生产订单里
    widget.purchaseOrderModel.consignment = consignment;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository().purchaseOrderDelivering(
                widget.purchaseOrderModel.code, widget.purchaseOrderModel),
            outsideDismiss: false,
            loadingText: '加载中。。。',
            entrance: '',
          );
        }).then((value) {
      PurchaseOrderBLoC.instance.refreshData('ALL');
      Navigator.of(context).pop();
      bool result = false;
      if (value != null) {
        result = value;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '确认发货成功',
              failTips: '确认发货失败',
              callbackResult: result,
            );
          });
    });
  }

  void saveProofingOrder(ConsignmentModel consignment) {
    widget.proofingModel.consignment = consignment;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ProofingOrderRepository().proofingDelivering(
                widget.proofingModel.code, widget.proofingModel),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      ProofingOrdersBLoC.instance.refreshData('ALL');
      Navigator.of(context).pop();
      bool result = false;
      if (value != null) {
        result = value;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '确认发货成功',
              failTips: '确认发货失败',
              callbackResult: result,
            );
          });
    });
  }

  void _showLogisticsSelect(List<CarrierModel> list) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(child: ListView(children: _builItems(context, list)));
      },
    );
  }

  List<Widget> _builItems(BuildContext context, List<CarrierModel> list) {
    List<Widget> widgets = new List();
    for (int i = 0; i < list.length; i++) {
      widgets.add(ListTile(
        title: Text('${list[i].name}'),
        onTap: () async {
          setState(() {
            carrierName = list[i].name;
            carrierCode = list[i].code;
          });
          Navigator.pop(context);
        },
      ));
    }
    return widgets;
  }
}
