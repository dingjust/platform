import 'package:b2b_commerce/src/business/search/sales_order_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
    return Scaffold(
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
    );
  }
}

class SalesOrderList extends StatelessWidget {
  final EnumModel status;

  SalesOrderList(this.status);

  @override
  Widget build(BuildContext context) {
    final List<SalesOrderModel> orders = <SalesOrderModel>[
      SalesOrderModel.fromJson({
        "code": "34938475200045",
        "status": "CREATED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
            },
          },
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
            },
          }
        ],
      }),
      SalesOrderModel.fromJson({
        "code": "34938475200045",
        "status": "CREATED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款2",
              "skuID": "NA89852509",
            },
          }
        ],
      })
    ];

    return ListView(
      children: orders.map((order) {
        return SalesOrderItem(order);
      }).toList(),
    );
  }
}

class SalesOrderItem extends StatelessWidget {
  final SalesOrderModel order;

  SalesOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(context),
        Column(
          children: _buildEntries(context),
        ),
        _buildSummary(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text('销售订单号：${order.code}'),
        ),
        Text('${order.status}')
      ],
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    return order.entries.map((entry) {
      return Row(
        children: <Widget>[
          entry.product.thumbnail != null ?
          Image.network(
            '${entry.product.thumbnail}',
            width: 220,
            height: 220,
          ) : Text('TODO: thumbnail'),
          Column(
            children: <Widget>[
              Text('${entry.product.name}'),
              Text('货号：${entry.product.skuID}'),
            ],
          )
        ],
      );
    }).toList();
  }

  Widget _buildSummary(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text.rich(TextSpan(children: <TextSpan>[
        TextSpan(text: '共${order.totalQuantity}件商品'),
        TextSpan(text: '  '),
        TextSpan(text: '合计：${order.totalPrice}'),
      ])),
    );
  }
}
