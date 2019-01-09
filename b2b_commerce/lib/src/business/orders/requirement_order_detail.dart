import 'package:flutter/material.dart';
import 'package:models/models.dart';

class RequirementOrderDetailPage extends StatefulWidget {
  final String code;

  const RequirementOrderDetailPage({Key key, this.code}) : super(key: key);

  _RequirementOrderDetailPageState createState() =>
      _RequirementOrderDetailPageState();
}

class _RequirementOrderDetailPageState
    extends State<RequirementOrderDetailPage> {
  RequirementOrderModel order = RequirementOrderModel.fromJson({
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
        "basePrice": 100.00,
        "entryNumber": 500,
      },
    ],
  });

  static Map<String, MaterialColor> _statusColors = {
    "PENDING_QUOTE": Colors.green,
    "COMPLETED": Colors.orange,
    "CANCELLED": Colors.red
  };

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
          '需求订单明细',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[_buildHeader(), _buildMain()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text('需求订单号：' + order.code),
                  flex: 1,
                ),
                Text(
                  order.status,
                  style: TextStyle(
                      fontSize: 15, color: _statusColors[order.status]),
                )
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text('发布时间: 1997-01-01'),
                flex: 1,
              ),
              Text(
                '已报价 6',
                style: TextStyle(fontSize: 15, color: Colors.red),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Column(
            children: _buildEntries(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                '共${order.totalQuantity}件商品',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            ],
          ),
          InfoRow(
            label: '加工类型',
            value: Text('包公包料'),
          ),
          InfoRow(
            label: '加工类型',
            value: Text('包公包料'),
          ),
          InfoRow(
            label: '加工类型',
            value: Text('包公包料'),
          )
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
                          Text(
                            '生产单价：￥ ${entry.basePrice}',
                            style: TextStyle(color: Colors.red),
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
}

class InfoRow extends StatelessWidget {
  const InfoRow({Key key, this.label, this.value}) : super(key: key);

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(fontSize: 16),
          ),
          value
        ],
      ),
    );
  }
}
