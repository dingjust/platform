import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryPurchaseListPage extends StatefulWidget{
  FactoryPurchaseListPage({
    Key key,
    @required this.factoryUid,
  }) : super(key: key);

  final String factoryUid;

  _FactoryPurchaseListPageState createState() => _FactoryPurchaseListPageState();
}

class _FactoryPurchaseListPageState extends State<FactoryPurchaseListPage>{
  final GlobalKey _globalKey = GlobalKey<_FactoryPurchaseListPageState>();

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
        body: PurchaseOrderList(factoryUid: widget.factoryUid,),
        floatingActionButton: ScrollToTopButton<PurchaseOrderBLoC>(),
      ),
    );
  }
}
