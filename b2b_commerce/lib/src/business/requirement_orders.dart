import 'package:b2b_commerce/src/business/search/requirement_order_search.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_QUOTE', '报价中'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已失效')
];

class RequirementOrdersPage extends StatefulWidget {
  _RequirementOrdersPageState createState() => _RequirementOrdersPageState();
}

class _RequirementOrdersPageState extends State<RequirementOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.grey),
          centerTitle: true,
          elevation: 0.5,
          title: Text(
            '需求订单管理',
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () => showSearch(
                  context: context, delegate: RequirementOrderSearchDelegate()),
            ),
          ],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black38,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: statuses.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
              isScrollable: false,
            ),
            body: TabBarView(
              children: <Widget>[
                RequirementOrderList(
                  status: statuses[0],
                ),
                RequirementOrderList(
                  status: statuses[1],
                ),
                RequirementOrderList(
                  status: statuses[2],
                ),
                RequirementOrderList(
                  status: statuses[3],
                )
              ],
            ),
          ),
        ));
  }
}

class RequirementOrderList extends StatelessWidget {
  RequirementOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  @override
  Widget build(BuildContext context) {
    List<RequirementOrderModel> orders = <RequirementOrderModel>[
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "PENDING_QUOTE",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ],
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
            },
            "entryNumber": 500,
          },
        ],
      }),
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "COMPLETED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              // "name": "山本风法少女长裙复古气质秋冬款",
              // "skuID": "NA89852509",
              "entryNumber": 500,
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ]
            },
            "entryNumber": 500,
          }
        ],
      }),
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "CANCELLED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
              "entryNumber": 500,
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ],
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i2/109570697/O1CN011H1GWjAIIrfgcfr_!!0-saturn_solar.jpg_220x220.jpg_.webp"
            },
            "entryNumber": 500,
          },
        ],
      }),
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "PENDING_QUOTE",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ],
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
            },
            "entryNumber": 500,
          },
        ],
      }),
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "COMPLETED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              // "name": "山本风法少女长裙复古气质秋冬款",
              // "skuID": "NA89852509",
              "entryNumber": 500,
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ]
            },
            "entryNumber": 500,
          }
        ],
      }),
      RequirementOrderModel.fromJson({
        "code": "34938475200045",
        "status": "CANCELLED",
        "totalQuantity": 10,
        "totalPrice": 300,
        "entries": [
          {
            "product": {
              "code": "NA89852509",
              "name": "山本风法少女长裙复古气质秋冬款",
              "skuID": "NA89852509",
              "entryNumber": 500,
              "majorCategory": {"name": "女装-T恤"},
              "supercategories": [
                {"name": "针织"}
              ],
              "thumbnail":
                  "https://img.alicdn.com/imgextra/i2/109570697/O1CN011H1GWjAIIrfgcfr_!!0-saturn_solar.jpg_220x220.jpg_.webp"
            },
            "entryNumber": 500,
          },
        ],
      }),
    ];

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: ListView(
        children: orders.map((order) {
          return RequirementOrderItem(
            order: order,
          );
        }).toList(),
      ),
    );
  }
}

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({Key key, this.order}) : super(key: key);

  final RequirementOrderModel order;

  static Map<String, MaterialColor> _statusColors = {
    "PENDING_QUOTE": Colors.green,
    "COMPLETED": Colors.orange,
    "CANCELLED": Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS_DETAIL);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
            _buildSummary()
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('需求订单号：' + order.code),
              ),
              Text(order.status,
                  style: TextStyle(color: _statusColors[order.status]))
            ],
          ),
          Text('发布时间: 1997-01-01'),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: entry.product.thumbnail != null
                              ? NetworkImage(entry.product.thumbnail)
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entry.product.name != null
                              ? Text(
                                  entry.product.name,
                                  style: TextStyle(fontSize: 15),
                                )
                              : Text(
                                  '暂无产品',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                          entry.product.skuID != null
                              ? Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    '货号：' + entry.product.skuID,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.yellow[50],
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "${entry.product.superCategories.first.name}   ${entry.product.majorCategory.name}   ${entry.entryNumber}件",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.orange),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }

  Widget _buildSummary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '已报价 6',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}
