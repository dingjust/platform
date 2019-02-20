import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'orders/production_detail.dart';

import 'package:models/models.dart';

final List<Tab> status = <Tab>[
  new Tab(text: '全部'),
  new Tab(text: '待分配'),
  new Tab(text: '备料中'),
  new Tab(text: '待裁剪'),
  new Tab(text: '裁剪中'),
  new Tab(text: '车缝中'),
  new Tab(text: '待验货'),
  new Tab(text: '待发货'),
  new Tab(text: '已发货'),
];

final List items = [
  {
    'orderCode': 'S20181224102141000007001',
    'consignmentCode': 'SGGW123164987111313156',
    'createTime': '2019-01-03',
    'imageURL': 'http://img.duoziwang.com/2018/06/2018010144149418.jpg',
    'productName': '羽绒服，棒球服，服装，短袖',
    'supplierCode': '8MD13GO10096',
    'total': '50',
    'userName': 'Mr.Zhang',
    'phone': '13123456789',
    'address': '广州市海珠区广州大道南10002'
  },
  {
    'orderCode': 'S20181224102141124576531',
    'consignmentCode': 'SGGW123164989806313156',
    'createTime': '2019-01-03',
    'imageURL': 'http://img.duoziwang.com/2018/06/2018010144149418.jpg',
    'productName': '牛仔裤，打底裤，运动裤',
    'supplierCode': '8MD13GO16986',
    'total': '50',
    'userName': 'Mr.Zhao',
    'phone': '13987654321',
    'address': '广州市海珠区广州大道北10002'
  }
];

List<Widget> _list = new List();

class ProductionOrdersPage extends StatefulWidget {
  @override
  _ProductionOrdersPage createState() => _ProductionOrdersPage();
}

class _ProductionOrdersPage extends State<ProductionOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text('生产订单'),
        ),
        body: new DefaultTabController(
          length: status.length,
          child: new Scaffold(
            appBar: new TabBar(
              unselectedLabelColor: Colors.black26,
                labelColor: Colors.black38,
                tabs: status,
                labelStyle: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black
                ),
                isScrollable: true,
            ),
            body: TabBarView(
              children: <Widget>[
                new Center(
                    child: new ListView(
                        children: ordersItem()
                    )
                ),
                Center(
                  child: Text('待分配订单'),
                ),
                Center(
                  child: Text('备料中订单'),
                ),
                Center(
                  child: Text('待裁剪订单'),
                ),
                Center(
                  child: Text('裁剪中订单'),
                ),
                Center(
                  child: Text('车缝中订单'),
                ),
                Center(
                  child: Text('待验货订单'),
                ),
                Center(
                  child: Text('待发货订单'),
                ),
                Center(
                  child: Text('已发货订单'),
                ),
              ],
            ),
          ),
        ));
  }

  List<Widget> ordersItem() {
    return <Widget>[
      new Card(
          child: new Column(children: [
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('订单编号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '待出库',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('生产单号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '裁剪中',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('创建订单时间  2019-01-03 11:48',
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                          fontSize: 14
                        )
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '已延期',
                        style: TextStyle(color: Colors.red)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
        new Divider(),
        new ListTile(
          title: new Text('面包服摸摸摸摸董赛娇十分骄傲司法局阿松放假啊',
              style: new TextStyle(fontWeight: FontWeight.w500)),
          leading: new Image.network(
            "http://img.duoziwang.com/2018/06/2018010144149418.jpg",
            width: 80,
          ),
          subtitle: new Text('供应商编号：8MD13GO10096'),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductionDetailPage(),
              ),
            );
          },
        ),
        new Divider(),
        new ListTile(trailing: new Text("共24件商品")),
      ]
          )
      ),
      new Card(
          child: new Column(children: [
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('订单编号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '待出库',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('生产单号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '裁剪中',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('创建订单时间  2019-01-03 11:48',
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        )
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '已延期',
                        style: TextStyle(color: Colors.red)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Divider(),
            new ListTile(
              title: new Text('面包服摸摸摸摸董赛娇十分骄傲司法局阿松放假啊',
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Image.network(
                "http://img.duoziwang.com/2018/06/2018010144149418.jpg",
                width: 80,
              ),
              subtitle: new Text('供应商编号：8MD13GO10096'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionDetailPage(),
                  ),
                );
              },
            ),
            new Divider(),
            new ListTile(trailing: new Text("共24件商品")),
          ]
          )
      ),
      new Card(
          child: new Column(children: [
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('订单编号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '待出库',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('生产单号：S20181224102141000007001',
                        style: new TextStyle(fontWeight: FontWeight.w500)),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '裁剪中',
                        style: TextStyle(color: Colors.amber)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    child: new Text('创建订单时间  2019-01-03 11:48',
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        )
                    ),
                    flex: 5,
                  ),
                  Expanded(
                    child: new Text(
                        '已延期',
                        style: TextStyle(color: Colors.red)
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            new Divider(),
            new ListTile(
              title: new Text('面包服摸摸摸摸董赛娇十分骄傲司法局阿松放假啊',
                  style: new TextStyle(fontWeight: FontWeight.w500)),
              leading: new Image.network(
                "http://img.duoziwang.com/2018/06/2018010144149418.jpg",
                width: 80,
              ),
              subtitle: new Text('供应商编号：8MD13GO10096'),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionDetailPage(),
                  ),
                );
              },
            ),
            new Divider(),
            new ListTile(trailing: new Text("共24件商品")),
          ]
          )
      ),
    ];
  }
}
