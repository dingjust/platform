import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:b2b_commerce/src/business/quote_orders.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class LogisticsInputPage extends StatefulWidget{

  final bool isProductionOrder;

  final PurchaseOrderModel purchaseOrderModel;

  final ProofingModel proofingModel;

  LogisticsInputPage({
    this.isProductionOrder:false,
    this.purchaseOrderModel,
    this.proofingModel,
  });

  _LogisicsInputPageState createState() => _LogisicsInputPageState();
}

class _LogisicsInputPageState extends State<LogisticsInputPage>{
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

  void loadData() async{
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
            ))
    );
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
                    child:  Container(
                      padding:EdgeInsets.only(left: 30),
                      child: Text(
                        '${carrierName == null || carrierName == ''
                            ? '选择快递/物流公司'
                            : carrierName}',
                        style: TextStyle(
                          fontSize: 16
                        ),
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
            onTap: () async{
              if (list != null && list.isNotEmpty) {
                _showLogisticsSelect(list);
              }else{
                showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('提示'),
                      children: <Widget>[
                        SimpleDialogOption(
                          child: Text('获取物流公司失败'),
                        ),
                      ],
                    );
                  },
                );
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

  Widget _buildButton(BuildContext context){
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
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () async{
                  bool result = false;
                  //把选中的物流公司放到Model
                  CarrierModel carrier = new CarrierModel();
                  carrier.code = carrierCode;
                  carrier.name = carrierName;
                  //把物流信息放到model
                  ConsignmentModel consignment = new ConsignmentModel();
                  consignment.trackingID = _orderNumberController.text;
                  consignment.carrierModel = carrier;
                  if(_orderNumberController.text != null && _orderNumberController.text != ''
                      && carrierCode != null && carrierCode != '') {
                    //生产单的确认发货
                    if (widget.isProductionOrder && widget.purchaseOrderModel != null) {
                      //把内容放到生产订单里
                      widget.purchaseOrderModel.consignmentModel = consignment;
                      result = await PurchaseOrderRepository()
                          .purchaseOrderDelivering(
                          widget.purchaseOrderModel.code,
                          widget.purchaseOrderModel);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) =>
                              PurchaseOrdersPage()), ModalRoute.withName('/'));
                      PurchaseOrderBLoC().refreshData('ALL');
                    }
                    //打样单的确认发货
                    else if(!widget.isProductionOrder && widget.proofingModel != null) {
                      widget.proofingModel.consignmentModel = consignment;
                      result = await ProofingOrderRepository()
                          .proofingDelivering(
                          widget.proofingModel.code,
                          widget.proofingModel);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) =>
                              QuoteOrdersPage()), ModalRoute.withName('/'));
                      QuoteOrdersBLoC().refreshData('ALL');
                    }

                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('提示'),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text('发货${result ? '成功' : '失败'}'),
                            ),
                          ],
                        );
                      },
                    );
                  }else{
                    showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (context) {
                        return SimpleDialog(
                          title: const Text('提示'),
                          children: <Widget>[
                            SimpleDialogOption(
                              child: Text('请选择物流公司和填写物流单号'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
            ),
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
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () async{
                  bool result = false;
                  if(widget.isProductionOrder){
                     result = await PurchaseOrderRepository()
                            .purchaseOrderDelivering(
                        widget.purchaseOrderModel.code,
                        widget.purchaseOrderModel);
                  }else{
                    result = await ProofingOrderRepository()
                        .proofingDelivering(
                        widget.proofingModel.code,
                        widget.proofingModel);
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) =>
                          PurchaseOrdersPage()), ModalRoute.withName('/'));
                  PurchaseOrderBLoC().refreshData('ALL');
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true, // user must tap button!
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('提示'),
                        children: <Widget>[
                          SimpleDialogOption(
                            child: Text('发货${result ? '成功' : '失败'}'),
                          ),
                        ],
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }



  void _showLogisticsSelect(List<CarrierModel> list) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: ListView(
              children: _builItems(context,list)
            )
        );
      },
    );
  }

  List<Widget> _builItems(BuildContext context,List<CarrierModel> list){
    List<Widget> widgets = new List();
    for(int i=0;i<list.length;i++){
      widgets.add(
        ListTile(
          title: Text('${list[i].name}'),
          onTap: () async {
            setState(() {
              carrierName = list[i].name;
              carrierCode = list[i].code;
            });
            Navigator.pop(context);
          },
        )
      );
    }
    return widgets;
  }

}