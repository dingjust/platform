import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'quote_order_detail.dart';

class QuoteOrderItem extends StatelessWidget {
  final QuoteEntryModel item;

  QuoteOrderItem({this.item});

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

    List<Widget> _rows = <Widget>[
      Container(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text('报价单号：' + item.order.code),
            ),
            Text('报价时间：' + item.order.creationTime.toString().substring(0, 10)),
          ],
        ),
      ),
      Row(
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
                      Expanded(
                        child: Column(
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
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 18),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
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
    ];

    if (item.order.state == QuoteState.SELLER_SUBMITTED) {
      _rows.add(
        Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 70, right: 20),
                child: ActionChip(
                  backgroundColor: Colors.red,
                  labelPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 13),
                  labelStyle: TextStyle(fontSize: 18),
                  label: Text('拒绝报价'),
                  onPressed: () {},
                ),
              ),
              ActionChip(
                backgroundColor: Colors.orange,
                labelPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 13),
                labelStyle: TextStyle(fontSize: 18),
                label: Text('确认报价'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuoteOrderDetailPage(item: item),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 30),
                    child: Text("工厂：" + item.order.belongTo.name),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text('报价：'),
                        Text(
                          item.order.totalPrice.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        Text('元'),
                      ],
                    ),
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
            ),
            Container(
              color: Colors.grey[50],
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('报价单号：' + item.order.code),
                        ),
                        Text('报价时间：' +
                            item.order.creationTime
                                .toString()
                                .substring(0, 10)),
                      ],
                    ),
                  ),
                  Row(
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
                                  Expanded(
                                    child: Column(
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
                                              item.order.totalQuantity
                                                  .toString() +
                                              '件',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 18),
                                        ),
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                    ),
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
                  Offstage(
                    offstage: item.order.state != QuoteState.SELLER_SUBMITTED
                        ? true
                        : false,
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 70, right: 20),
                            child: ActionChip(
                              backgroundColor: Colors.red,
                              labelPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 13),
                              labelStyle: TextStyle(fontSize: 18),
                              label: Text('拒绝报价'),
                              onPressed: () {},
                            ),
                          ),
                          ActionChip(
                            backgroundColor: Colors.orange,
                            labelPadding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 13),
                            labelStyle: TextStyle(fontSize: 18),
                            label: Text('确认报价'),
                            onPressed: () {},
                          ),
                        ],
                      ),
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
}
