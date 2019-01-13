import 'package:b2b_commerce/src/business/orders/provider/sales_order_bloc_provider.dart';
import 'package:b2b_commerce/src/business/search/sales_order_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'orders/sales_order_detail.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('PENDING_DELIVERY', '待发货'),
  EnumModel('SHIPPED', '已发货'),
  EnumModel('COMPLETED', '已完成'),
];

class SalesOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SalesOrderBlocProvider(
      child: Scaffold(
        appBar: AppBar(
          title: Text('销售订单'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(context: context, delegate: SalesOrderSearchDelegate()),
            ),
          ],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black38,
              tabs: statuses.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              isScrollable: true,
            ),
            body: TabBarView(
              children: <Widget>[
                SalesOrderList(statuses[0]),
                SalesOrderList(statuses[1]),
                SalesOrderList(statuses[2]),
                SalesOrderList(statuses[3]),
                SalesOrderList(statuses[4]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesOrderList extends StatelessWidget {
  final EnumModel status;

  SalesOrderList(this.status);

  @override
  Widget build(BuildContext context) {
    final bloc = SalesOrderBlocProvider.of(context);

    if (status.code == 'ALL') {
      bloc.filterByStatuses(statuses.map((status) {
        return status.code;
      }).toSet());
    } else {
      bloc.filterByStatuses(Set.of([status.code]));
    }

    return StreamBuilder<List<SalesOrderModel>>(
      stream: bloc.stream,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<SalesOrderModel>> snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(color: Colors.grey[100]),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView(
              children: snapshot.data.map((order) {
                return SalesOrderItem(order);
              }).toList(),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SalesOrderItem extends StatelessWidget {
  final SalesOrderModel order;

  SalesOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          Column(
            children: _buildEntries(context),
          ),
          _buildSummary(context),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '销售订单号：${order.code}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                SalesOrderStatusLocalizedMap[order.status],
                style: TextStyle(color: Color(0xFF56C275), fontSize: 16.0),
              )
            ],
          ),
          Text(
            '订单创建时间：${order.creationTime}',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    return order.entries.map((entry) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaleOrderDetail(),
            ),
          );
        },
        child: Container(
          color: Color(0xFFFAFAFA),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("${entry.product.thumbnail}"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${entry.product.name}',
                        style: TextStyle(fontSize: 16.0, color: Color(0xFF323232)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                        child: Text(
                          '货号：${entry.product.skuID}',
                          style: TextStyle(fontSize: 14.0, color: Color(0xFF969696)),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSummary(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '共${order.totalQuantity}件商品，合计：${order.totalPrice}',
          style: TextStyle(color: Color(0xFFFF4444), fontSize: 16.0),
        ),
        RaisedButton(
          child: Text('支付'),
        )
      ],
    );
  }
}
