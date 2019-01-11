import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'dart:math';

class QuoteOrderDetailPage extends StatelessWidget {
  QuoteEntryModel item;

  QuoteOrderDetailPage({this.item});

  //格式星级
  List<Icon> formatStar(int level) {
    List<Icon> icons = <Icon>[];
    for (int i = 0; i < level; i++) {
      icons.add(Icon(
        Icons.star,
        size: 18,
        color: Colors.orange,
      ));
    }

    for (int i = 0; i < 5 - level; i++) {
      icons.add(Icon(
        Icons.star,
        size: 18,
        color: Colors.grey[400],
      ));
    }

    return icons;
  }

  @override
  Widget build(BuildContext context) {
    Color _stateTextColor;
    if (item.order.state == QuoteState.SELLER_SUBMITTED) {
      _stateTextColor = Colors.green;
    } else if (item.order.state == QuoteState.BUYER_APPROVED) {
      _stateTextColor = Colors.blue;
    } else if (item.order.state == QuoteState.BUYER_REJECTED) {
      _stateTextColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('报价详情'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
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
                          color: _stateTextColor,
                          fontWeight: FontWeight.w800,
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
          ),
          Card(
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
                                    child: Text(item.order.belongTo.name),
                                  ),
                                  Row(
                                    children: formatStar(
                                        item.order.belongTo.starLevel),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text('历史接单'),
                                Text(
                                  item.order.belongTo.historyOrdersCount
                                      .toString(),
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
                                    item.order.belongTo.contactAddress
                                        .cityDistrict.name,
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
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Image.network(
                    item.product?.thumbnail != null
                        ? item.product.thumbnail
                        : 'http://bpic.588ku.com/element_origin_min_pic/01/49/18/85574457aa5ed76.jpg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.fill,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: item.product?.name != null
                                    ? Text(
                                        item.product.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        '暂无产品',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  item.product?.skuID != null
                                      ? Text(
                                          '货号：' + item.product.skuID,
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Text(''),
                                  Text(
                                    item.product.majorCategory.name +
                                        "," +
                                        item.product.minorCategory.name +
                                        "," +
                                        item.order.totalQuantity.toString() +
                                        '件',
                                    style: TextStyle(
                                        color: Colors.orange, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '需求订单号：' + '459802454625245',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
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
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 15),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text('交货时间：' +
                  item.order.expectedDeliveryDate.toString().substring(0, 10)),
            ),
          ),
          Card(
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
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      children: item.order.attachments.map((attachment) {
                        return Image.network(attachment);
                      }).toList(),
                    ),
                  ],
                )),
          ),
          Card(
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
                      padding: EdgeInsets.only(top: 10),
                      child: Text('确定前请先与我厂沟通好样衣事宜，谢谢。'),
                    ),
                  ],
                )),
          ),
          Offstage(
            offstage:
                item.order.state != QuoteState.SELLER_SUBMITTED ? true : false,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ActionChip(
                      backgroundColor: Colors.red,
                      labelPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                      labelStyle: TextStyle(fontSize: 16),
                      label: Text('拒绝报价'),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: ActionChip(
                      backgroundColor: Colors.orange,
                      labelPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                      labelStyle: TextStyle(fontSize: 16),
                      label: Text('确认报价'),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
