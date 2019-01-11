import 'package:flutter/material.dart';

class SaleOrderDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单详情'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 135.0,
            child: Center(
              child: Text('步骤'),
            ),
          ),
          Container(
            height: 15.0,
            color: Color(0xFFF5F5F5),
          ),
          Container(
            height: 114.0,
            padding: EdgeInsets.fromLTRB(15.0, 22.0, 15.0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        '销售订单号：1234567890',
                        style: TextStyle(fontSize: 16.0, color: Color(0xFF000000))
                    ),
                    Text(
                        '已完成',
                        style: TextStyle(fontSize: 18.0, color: Color(0xFF168DFF))
                    )
                  ],
                ),
                Text(
                    '创建时间：2019-01-10 16:30',
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF000000))
                )
              ],
            ),
          ),
          Container(
            height: 15.0,
            color: Color(0xFFF5F5F5),
          ),
          Container(
            height: 135.0,
            child: Center(
              child: Text('地址管理'),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 110.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://g-search3.alicdn.com/img/bao/uploaded/i4/i2/3048914385/O1CN011iJqif1iGNEAIaHIb_!!0-item_pic.jpg_360x360Q90.jpg_.webp"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 5.0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '法式复古裙egg矮个子毛衣',
                          style: TextStyle(fontSize: 16.0, color: Color(0xFF323232)),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                          child: Text(
                            '货号：NA89898989',
                            style: TextStyle(fontSize: 14.0, color: Color(0xFF969696)),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        Text(
                          '生产单价：￥56',
                          style: TextStyle(fontSize: 16.0, color: Color(0xFFFF4444)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Table(
                  border: TableBorder.all(width: 1.0,color: Colors.transparent),
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '颜色',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '价格',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '尺码',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '数量',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '黑色',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'XS',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'S',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'M',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'L',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                  ],
                ),
                Table(
                  border: TableBorder.all(width: 1.0,color: Colors.transparent),
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '颜色',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '价格',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '尺码',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFEEEEEE),
                          alignment: Alignment.center,
                          child: Text(
                            '数量',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '红色',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'XS',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'S',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '￥100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            'M',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                        TableCell(child: Container(
                          color: Color(0xFFFAFAFA),
                          alignment: Alignment.center,
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                          ),
                          height: 40.0,
                        )),
                      ],
                    ),
                  ],
                ),
                Text(
                  '共70件商品 合计：￥7000',
                  style: TextStyle(fontSize: 16.0, color: Color(0xFFFF4444)),
                )
              ],
            ),
          ),
          Container(
            height: 15.0,
            color: Color(0xFFF5F5F5),
          ),
          Container(
            height: 135.0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '备注',
                    style: TextStyle(fontSize: 20.0, color: Color(0xFF969696)),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 15.0,
            color: Color(0xFFF5F5F5),
          ),
          Container(
            height: 135.0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '物流信息',
                    style: TextStyle(fontSize: 20.0, color: Color(0xFF969696)),
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
