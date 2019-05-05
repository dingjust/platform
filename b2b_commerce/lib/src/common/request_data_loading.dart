import 'package:b2b_commerce/src/business/orders/production_progresses.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/proofing_orders.dart';
import 'package:b2b_commerce/src/business/purchase_orders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class RequestDataLoadingPage extends StatefulWidget {
  final bool loading;
  Function dismissCallback;
  String loadingText;
  bool outsideDismiss;
  Future<dynamic> requestCallBack;
  bool callbackResult;
  Future<void> callbackExecution;
  String entrance;

  RequestDataLoadingPage({
    Key key,
    this.loading,
    this.loadingText = "loading...",
    this.outsideDismiss = true,
    this.dismissCallback,
    @required this.requestCallBack,
    this.callbackResult,
    this.callbackExecution,
    @required this.entrance,
    })
      : super(key: key);

  @override
  _RequestDataLoadingPageState createState() => _RequestDataLoadingPageState();
}

class _RequestDataLoadingPageState extends State<RequestDataLoadingPage> {

  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback();
    }
    print('1231'+widget.callbackResult.toString());
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.requestCallBack != null) {
        widget.requestCallBack.then((value) {
        Navigator.of(context).pop(value);

        if(widget.entrance == 'production'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ProductionProgressesPage(
                  order: value,
                ),
          ),
          );
        }

        if(widget.entrance == 'createPurchaseOrder'){
          ProductionBLoC.instance.refreshData();
          PurchaseOrderBLoC.instance.refreshData('ALL');
          if(value != null){
            _requestMessage(context, '保存成功', value);
          }else{
            Navigator.of(context).pop();
          }
        }

        if(widget.entrance == 'purchaseOrders'){
          returnPurchaseOrders();
        }

        if(widget.entrance == 'returnProofingOrders'){
          returnProofingOrders();
        }

        if(widget.entrance == 'quoteOrder'){
          QuoteOrdersBLoC.instance.refreshData('ALL');
          if(value != null){
            _requestMessage(context, '保存成功', value);
          }else{
            Navigator.of(context).pop();
          }
        }

        if(widget.entrance == 'proofingOrder'){
          ProofingOrdersBLoC.instance.refreshData('ALL');
          if(value != null){
            _requestMessage(context, '保存成功', value);
          }else{
            Navigator.of(context).pop();
          }
        }


      });
    }
  }

  Future<void> _requestMessage(BuildContext context,String message,String code) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
                fontSize: 16
            ),),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 22,
                ),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if(code!= null){
                  if(widget.entrance == 'createPurchaseOrder'){
                    PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(code);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) =>
                            PurchaseOrderDetailPage(order: model)
                        ), ModalRoute.withName('/'));
                  }
                  if(widget.entrance == 'quoteOrder'){
                    //查询明细
                    QuoteModel detailModel = await QuoteOrderRepository().getQuoteDetails(code);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => QuoteOrderDetailPage(item: detailModel)),
                        ModalRoute.withName('/'));
                  }
                  if(widget.entrance == 'proofingOrder'){
                    ProofingModel detailModel = await ProofingOrderRepository()
                        .proofingDetail(code);
                    if (detailModel != null) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => ProofingOrderDetailPage(
                                model: detailModel,
                              )),
                          ModalRoute.withName('/'));
                    }
                  }

                }else{
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getPurchaseOrderDetail(String code) async {
    PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(code);
    PurchaseOrderBLoC.instance.refreshData('ALL');
    if(model!=null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              PurchaseOrderDetailPage(order: model)
          ), ModalRoute.withName('/'));
    }else{
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) =>
              PurchaseOrdersPage()
          ), ModalRoute.withName('/'));
    }
  }

  Future<void> returnPurchaseOrders(){
    PurchaseOrderBLoC.instance.refreshData('ALL');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>
            PurchaseOrdersPage()
        ), ModalRoute.withName('/'));
  }

  Future<void> returnProofingOrders(){
    ProofingOrdersBLoC().refreshData('ALL');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>
            ProofingOrdersPage()), ModalRoute.withName('/'));

  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: new Center(
          child: new SizedBox(
            width: 120.0,
            height: 120.0,
            child: new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      widget.loadingText,
                      style: new TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
