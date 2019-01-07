import 'package:flutter/material.dart';

class SaleOrderItem extends StatelessWidget{
  @override
  Widget build(BuildContext context ){
    List<Widget> items = [
      Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                  width: 100.0,
                  height: 100.0,
                ),
                Text('原创女士棉衣2019')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('颜色：浅灰/尺码：XL'),
                Text('￥380'),
                Text('X3'),
              ],
            )
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.network(
                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                  width: 100.0,
                  height: 100.0,
                ),
                Text('原创女士棉衣2019')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('颜色：浅灰/尺码：XL'),
                Text('￥380'),
                Text('X3'),
              ],
            )
          ],
        ),
      ),
    ];
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      children: <Widget>[
        Card(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('订单编号：1234567890'),
                    Text('待付款',style: TextStyle(color: Colors.amber))
                  ],
                ),
                Text('订单创建时间：2018-12-19 09:58:19'),
                ListView(
                  shrinkWrap: true,
                  children: items,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('共计5件商品 合计：￥800'),
                    RaisedButton(
                      child: Text('支付'),
                    )
                  ],
                )
              ],
            ),
          )
        ),
        Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('订单编号：1234567890'),
                      Text('待付款',style: TextStyle(color: Colors.amber))
                    ],
                  ),
                  Text('订单创建时间：2018-12-19 09:58:19'),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('共计5件商品 合计：￥800'),
                      RaisedButton(
                        child: Text('支付'),
                      )
                    ],
                  )
                ],
              ),
            )
        ),
        Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('订单编号：1234567890'),
                      Text('待付款',style: TextStyle(color: Colors.amber))
                    ],
                  ),
                  Text('订单创建时间：2018-12-19 09:58:19'),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('共计5件商品 合计：￥800'),
                      RaisedButton(
                        child: Text('支付'),
                      )
                    ],
                  )
                ],
              ),
            )
        ),
        Card(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('订单编号：1234567890'),
                      Text('待付款',style: TextStyle(color: Colors.amber))
                    ],
                  ),
                  Text('订单创建时间：2018-12-19 09:58:19'),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  'https://img.alicdn.com/imgextra/i3/1860270913/O1CN011IcC4vOIEr9xdXw_!!0-item_pic.jpg_430x430q90.jpg',
                                  width: 100.0,
                                  height: 100.0,
                                ),
                                Text('原创男士棉衣2018')
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('颜色：浅灰/尺码：XL'),
                                Text('￥160'),
                                Text('X2'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('共计5件商品 合计：￥800'),
                      RaisedButton(
                        child: Text('支付'),
                      )
                    ],
                  )
                ],
              ),
            )
        ),
      ],
    );
  }
}