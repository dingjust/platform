import 'package:flutter/material.dart';
import 'orders/sales_order_item.dart';

final List<Tab> status = <Tab>[
  new Tab(text: '全部'),
  new Tab(text: '待付款'),
  new Tab(text: '待发货'),
  new Tab(text: '已发货'),
  new Tab(text: '已完成'),
];

class SalesOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单'),
      ),
      body: DefaultTabController(
        length: status.length,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black38,
            tabs: status,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black
            ),
            isScrollable: true,
          ),
          body: TabBarView(
            children: <Widget>[
              SaleOrderItem(),
              Center(
                child: Text('待付款订单'),
              ),
              Center(
                child: Text('待发货订单'),
              ),
              Center(
                child: Text('已发货订单'),
              ),
              Center(
                child: Text('已完成订单'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
