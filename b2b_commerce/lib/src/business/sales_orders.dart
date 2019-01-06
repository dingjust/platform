import 'package:flutter/material.dart';
import 'orders/sales_order_item.dart';

class SalesOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('销售订单'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Text('全部')),
              Tab(icon: Text('待付款')),
              Tab(icon: Text('待发货')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            SaleOrderItem(),
            Center(
              child: Text('待付款订单'),
            ),
            Center(
              child: Text('待发货订单'),
            )
          ],
        ),
      ),
    );
  }
}
