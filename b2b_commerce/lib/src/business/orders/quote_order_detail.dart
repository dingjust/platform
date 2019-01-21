import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class QuoteOrderDetailPage extends StatelessWidget {
  final QuoteEntryModel item;

  const QuoteOrderDetailPage({this.item});

  static Map<QuoteState, MaterialColor> _statesColor = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '报价详情',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _buildOrderState(),
          _buildFactory(),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: _buildProduct(),
            ),
          ),
          _buildQuoteCost(),
          _buildDeliveryDate(),
          _buildAttachment(),
          _buildRemark(),
          _buildActionChip(),
        ],
      ),
    );
  }

  Widget _buildOrderState() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('需求订单号：' + item.order.requirementOrderCode),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('报价单号：' + item.order.code),
                ),
                Text(
                  QuoteStateLocalizedMap[item.order.state],
                  style: TextStyle(
                    color: _statesColor[item.order.state],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('报价时间：' +
                  item.order.creationTime.toString().substring(0, 10)),
            )
          ],
        ),
      ),
    );
  }

  _buildFactory() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '报价工厂',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                item.order.belongTo.name,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Stars(
                              starLevel: item.order.belongTo.starLevel,
                              highlightOnly: false,
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text('历史接单'),
                          Text(
                            item.order.belongTo.historyOrdersCount.toString(),
                            style: TextStyle(color: Colors.red),
                          ),
                          Text('单，报价成功率'),
                          Text(
                            (item.order.belongTo.orderedSuccessRate * 100)
                                    .round()
                                    .toString() +
                                '%',
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          item.order.belongTo.contactAddress.city.name +
                              item.order.belongTo.contactAddress.cityDistrict
                                  .name,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 22,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProduct() {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: item.product.thumbnail != null
                    ? NetworkImage(item.product.thumbnail)
                    : AssetImage(
                        'temp/picture.png',
                        package: "assets",
                      ),
                fit: BoxFit.cover,
              )),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                item.product?.name != null
                    ? Text(
                        item.product.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        //overflow: TextOverflow.ellipsis,
                      )
                    : Text(
                        '暂无产品',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                item.product?.skuID != null
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '货号：' + item.product.skuID,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.product.majorCategory.name +
                        "," +
                        item.product.minorCategory.name +
                        "," +
                        item.order.totalQuantity.toString() +
                        '件',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuoteCost() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '报价费用',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('面料单价'),
                  ),
                  Text(
                    '￥' + item.order.unitPriceOfFabric.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('辅料单价'),
                  ),
                  Text(
                    '￥' + item.order.unitPriceOfExcipients.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('加工单价'),
                  ),
                  Text(
                    '￥' + item.order.unitPriceOfProcessing.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '费用合计'
                        '￥' +
                        (item.order.unitPriceOfFabric +
                                item.order.unitPriceOfExcipients +
                                item.order.unitPriceOfProcessing)
                            .toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('样衣费用'),
                  ),
                  Text(
                    '￥' + item.order.costOfSamples.toString(),
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryDate() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Text('交货时间：' +
            item.order.expectedDeliveryDate.toString().substring(0, 10)),
      ),
    );
  }

  Widget _buildAttachment() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(color: Colors.grey),
              ),
              Attachments(list: item.order.attachments),
            ],
          )),
    );
  }

  Widget _buildRemark() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 15),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '备注',
                style: TextStyle(color: Colors.grey),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text('确定前请先与我厂沟通好样衣事宜，谢谢。'),
              ),
            ],
          )),
    );
  }

  Widget _buildActionChip() {
    return Offstage(
      offstage: item.order.state != QuoteState.SELLER_SUBMITTED ? true : false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Row(
          children: <Widget>[
            Expanded(
              child: ActionChip(
                backgroundColor: Colors.red,
                labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                labelStyle: TextStyle(fontSize: 16),
                label: Text('拒绝报价'),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: ActionChip(
                backgroundColor: Colors.orange,
                labelPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                labelStyle: TextStyle(fontSize: 16),
                label: Text('确认报价'),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
