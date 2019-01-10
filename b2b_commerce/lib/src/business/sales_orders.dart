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
        "creationtime": DateTime.now().toString(),
        "entries": [
          {
            "product": {
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
            },
          },
          {
            "product": {
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
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
        "creationtime": DateTime.now().toString(),
        "entries": [
          {
            "product": {
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg",
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
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Padding(
        padding: EdgeInsets.all(10.0),
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
      ),
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
                '${order.status}',
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
      return Container(
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
