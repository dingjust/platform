import 'package:flutter/material.dart';
import 'package:models/models.dart';

import '../../my/address/address_form.dart';

class SaleOrderDetail extends StatelessWidget {

  final List<AddressModel> addresses = <AddressModel>[
    AddressModel(
      fullname: '华安',
      cellphone: '13660339514',
      region: RegionModel(name: '广东省'),
      city: CityModel(code: 'CN-01-01', name: '广州市'),
      cityDistrict: DistrictModel(code: 'CN-01-01', name: '海珠区'),
      line1: '云顶同创汇A01',
      defaultAddress: true,
    ),
  ];

  final List<SalesOrderModel> orders = <SalesOrderModel>[
    SalesOrderModel.fromJson({
      "code": "34938475200045",
      "status": "PENDING_PAYMENT",
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
      "status": "PENDING_PAYMENT",
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

  static Map<SalesOrderStatus, MaterialColor> _statusColors = {
    SalesOrderStatus.PENDING_PAYMENT: Colors.green,
    SalesOrderStatus.PENDING_DELIVERY: Colors.orange,
    SalesOrderStatus.SHIPPED: Colors.red,
    SalesOrderStatus.COMPLETED: Colors.green
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('销售订单详情'),
      ),
      body: ListView(
        children: <Widget>[
          _buildPlaceholder(),
          _buildOverview(),
          _buildPlaceholder(),
          _buildAddress(context),
          _buildMain(),
          _buildPlaceholder(),
          _buildRemarks(),
          _buildPlaceholder(),
          _buildExpress(),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 15.0,
      color: Color(0xFFF5F5F5),
    );
  }

  Widget _buildOverview() {
    return Container(
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
    );
  }

  Widget _buildRow(String name, String telephone, bool isDefaultAddress) {
    List<Container> containers = <Container>[
      Container(
        padding: EdgeInsets.only(right: 22.0),
        child: Column(
          children: <Widget>[
            Text(name),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(right: 22.0),
        child: Column(
          children: <Widget>[
            Text(
              telephone,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    ];

    if (isDefaultAddress) {
      containers.add(
        Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Text(
                '默认地址',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Row(children: containers);
  }

  Widget _buildAddress(context) {
    List<ListTile> tiles = this.addresses.map((address) {
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressFormPage(address: address),
            ),
          );
        },
        title: _buildRow(
          address.fullname,
          address.cellphone,
          address.defaultAddress,
        ),
        subtitle: Text(address.details),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Container(
      height: 135.0,
      child: ListView(children: tiles),
    );
  }

  Widget _buildMain() {
    return Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5.0, 20.0, 15.0, 20.0),
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
      ],
    );
  }

  Widget _buildRemarks() {
    return Container(
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
    );
  }

  Widget _buildExpress() {
    return Container(
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
    );
  }
}
