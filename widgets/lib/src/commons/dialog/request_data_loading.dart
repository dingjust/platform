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

class RequestDataLoading extends StatefulWidget {
  final bool loading;
  Function dismissCallback;
  String loadingText;
  bool outsideDismiss;
  Future<dynamic> requestCallBack;
  bool callbackResult;
  Future<void> callbackExecution;
  String entrance;
  String keyword;
  String Function() onPress;

  RequestDataLoading({
    Key key,
    this.loading,
    this.loadingText = "loading...",
    this.outsideDismiss = true,
    this.dismissCallback,
    @required this.requestCallBack,
    this.callbackResult,
    this.callbackExecution,
    @required this.entrance,
    this.keyword,
  }) : super(key: key);

  @override
  _RequestDataLoadingPageState createState() => _RequestDataLoadingPageState();
}

class _RequestDataLoadingPageState extends State<RequestDataLoading> {
  _dismissDialog() {
    if (widget.dismissCallback != null) {
      widget.dismissCallback();
    }
    print('1231' + widget.callbackResult.toString());
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (widget.requestCallBack != null) {
      widget.requestCallBack.then((value) {
        Navigator.of(context).pop(value);

        if (widget.entrance == 'production') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionProgressesPage(
                    order: value,
                  ),
            ),
          );
        }

        if (widget.entrance == 'createPurchaseOrder') {
          ProductionBLoC.instance.refreshData('');
          PurchaseOrderBLoC.instance.refreshData('ALL');
//          if(value != null){
//            _requestMessage(context, '保存成功', value);
//          }else{
//            Navigator.of(context).pop(value);
//          }
        }

        if (widget.entrance == 'purchaseOrders') {
          returnPurchaseOrders();
        }

        if (widget.entrance == 'returnProofingOrders') {
          returnProofingOrders();
        }

        if (widget.entrance == 'quoteOrder') {
          QuoteOrdersBLoC.instance.refreshData('ALL');
        }

        if (widget.entrance == 'proofingOrder') {
          ProofingOrdersBLoC.instance.refreshData('ALL');
          if (value != null) {
          } else {
            Navigator.of(context).pop();
          }
        }

        if (widget.entrance == 'apparelProduct') {
          if (widget.keyword == null) {
            ApparelProductBLoC.instance.filterByStatuses('ALL');
          } else {
            ApparelProductBLoC.instance.getData(widget.keyword);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getPurchaseOrderDetail(String code) async {
    PurchaseOrderModel model =
        await PurchaseOrderRepository().getPurchaseOrderDetail(code);
    PurchaseOrderBLoC.instance.refreshData('ALL');
    if (model != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => PurchaseOrderDetailPage(order: model)),
          ModalRoute.withName('/'));
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => PurchaseOrdersPage()),
          ModalRoute.withName('/'));
    }
  }

  Future<void> returnPurchaseOrders() {
    PurchaseOrderBLoC.instance.refreshData('ALL');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PurchaseOrdersPage()),
        ModalRoute.withName('/'));
  }

  Future<void> returnProofingOrders() {
    ProofingOrdersBLoC().refreshData('ALL');
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ProofingOrdersPage()),
        ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: widget.outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child:  Center(
          child:  SizedBox(
            width: 120.0,
            height: 120.0,
            child:  Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   CircularProgressIndicator(),
                   Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child:  Text(
                      widget.loadingText,
                      style:  TextStyle(fontSize: 12.0),
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

class LoadingUtil {
  static Future loadingDialog(BuildContext context, Future future,
      String loadingText, String entrance) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: future,
            outsideDismiss: false,
            loadingText: loadingText,
            entrance: entrance,
          );
        });
  }
}
