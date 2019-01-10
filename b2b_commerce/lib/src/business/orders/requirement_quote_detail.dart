import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class RequirementQuoteDetailPage extends StatefulWidget {
  _RequirementQuoteDetailPageState createState() =>
      _RequirementQuoteDetailPageState();
}

class _RequirementQuoteDetailPageState
    extends State<RequirementQuoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    List<QuoteModel> quotes = <QuoteModel>[
      QuoteModel.fromJson({
        "code": "34938475200045",
        "creationtime": DateTime.now().toString(),
        "belongTo": {"name": "广州好辣制衣厂"},
        "state": "BUYER_APPROVED",
        "totalPrice": 360.00,
        "deliveryAddress": {
          "region": {"name": "广东"},
          "city": {"name": "广州"},
          "cityDistrict": {"name": "白云"}
        }
      }),
      QuoteModel.fromJson({
        "code": "34938475200045",
        "creationtime": DateTime.now().toString(),
        "belongTo": {"name": "广州好辣制衣厂"},
        "state": "BUYER_REJECTED",
        "totalPrice": 360.00,
        "deliveryAddress": {
          "region": {"name": "广东"},
          "city": {"name": "广州"},
          "cityDistrict": {"name": "白云"}
        }
      }),
      QuoteModel.fromJson({
        "code": "34938475200045",
        "creationtime": DateTime.now().toString(),
        "belongTo": {"name": "广州好辣制衣厂"},
        "state": "SELLER_SUBMITTED",
        "totalPrice": 360.00,
        "deliveryAddress": {
          "region": {"name": "广东"},
          "city": {"name": "广州"},
          "cityDistrict": {"name": "白云"}
        }
      }),
      QuoteModel.fromJson({
        "code": "34938475200045",
        "creationtime": DateTime.now().toString(),
        "belongTo": {"name": "广州好辣制衣厂"},
        "state": "BUYER_APPROVED",
        "totalPrice": 360.00,
        "deliveryAddress": {
          "region": {"name": "广东"},
          "city": {"name": "广州"},
          "cityDistrict": {"name": "白云"}
        }
      })
    ];

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '报价详情',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[100],
        child: ListView(
          children: _buildQuotes(quotes),
        ),
      ),
    );
  }

  List<Widget> _buildQuotes(List<QuoteModel> quotes) {
    return quotes
        .map((quote) => Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: QuoteItem(
                model: quote,
              ),
            ))
        .toList();
  }
}

class QuoteItem extends StatelessWidget {
  const QuoteItem({Key key, @required this.model}) : super(key: key);

  final QuoteModel model;

  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.BUYER_APPROVED: Colors.green,
    QuoteState.BUYER_REJECTED: Colors.red,
    QuoteState.SELLER_SUBMITTED: Colors.orange
  };

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[_buildHeader(), _buildOrderRow(), _buildMain()],
        ));
  }

  Widget _buildHeader() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("报价：￥${model.totalPrice}"),
            Text(
              QuoteStateLocalizedMap[model.state],
              style: TextStyle(color: _statusColors[model.state]),
            )
          ],
        ));
  }

  Widget _buildOrderRow() {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.grey[300]))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("报价单号：${model.code}"),
            Text("报价时间：${DateFormatUtil.format(model.creationTime)}")
          ],
        ));
  }

  Widget _buildMain() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: InkWell(
        onTap: () {
          print('ssss');
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 140,
                  child: Text(
                    model.belongTo.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stars(
                              starLevel: 5,
                              color: Color.fromRGBO(255, 183, 0, 1)),
                        ],
                      ),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        model.deliveryAddress.regionCityAndDistrict,
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      )
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: '历史接单',
                      style: TextStyle(color: Colors.black54),
                      children: <TextSpan>[
                        TextSpan(
                            text: '214', style: TextStyle(color: Colors.red)),
                        TextSpan(
                            text: '单,报价成功率',
                            style: TextStyle(color: Colors.black54)),
                        TextSpan(
                            text: '34%', style: TextStyle(color: Colors.red))
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
