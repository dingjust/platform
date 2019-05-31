import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CompanyPurchaseListPage extends StatefulWidget{
  CompanyPurchaseListPage({
    Key key,
    @required this.companyUid,
  }) : super(key: key);

  final String companyUid;

  _CompanyPurchaseListPageState createState() => _CompanyPurchaseListPageState();
}

class _CompanyPurchaseListPageState extends State<CompanyPurchaseListPage>{
  final GlobalKey _globalKey = GlobalKey<_CompanyPurchaseListPageState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    PurchaseOrderBLoC.instance.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
      key: _globalKey,
      bloc: PurchaseOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('全部生产单'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: PurchaseOrderList(companyUid: widget.companyUid,),
        floatingActionButton: ScrollToTopButton<PurchaseOrderBLoC>(),
      ),
    );
  }
}
