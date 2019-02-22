import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class FactoryItem extends StatelessWidget {
  const FactoryItem(
      {Key key,
      @required this.model,
      this.showButton = false,
      this.hasInvited = false})
      : super(key: key);

  final FactoryModel model;

  ///是否显示按钮
  final bool showButton;

  ///是否已经邀请
  final bool hasInvited;

  @override
  Widget build(BuildContext context) {
    SupplierModel supplierModel = SupplierModel.fromJson({
      'factory': {
        'profilePicture':
        'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
        'uid': 'BB123456',
        'name': '草帽工厂',
        'starLevel': 5,
        'historyOrdersCount': 35,
        'responseQuotedTime': 50,
        'email': 'monkey.D.luffy@163.com',
        'phone': '020-12345678',
        'cooperationModes': ['FOB'],
        'developmentCapacity': true,
        'monthlyCapacityRanges': 'MCR003',
        'latheQuantity': 5,
        'contactPerson': 'luffy',
        'contactPhone': '13123456789',
        'address': '广东省广州市海珠区广州大道南',
        'contactAddress': {
          'fullname': "张三",
          'cellphone': '13123456789',
          'region': {'isocode': 'R123', 'name': '广东省'},
          'city': {'code': 'C123', 'name': '广州市'},
          'cityDistrict': {'code': 'D123', 'name': '海珠区'},
          'line1': '广州大道南',
        },
        'categories': [
          {
            'code': '1001',
            'name': '卫衣',
          },
          {
            'code': '1002',
            'name': '毛衣',
          },
        ],
        'scaleRange': 'SR005',
        'registrationDate': DateTime.now().toString(),
        'taxNumber': '41553315446687844',
        'bankOfDeposit': '中国工商银行',
        'certificate': [
          {
            'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg',
          },
          {
            'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg',
          },
          {
            'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg',
          },
        ],
        'cooperativeBrands': [
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
          {
            'profilePicture':
            'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
            'uid': 'BB123456',
            'name': '草帽工厂',
            'starLevel': 5,
            'email': 'monkey.D.luffy@163.com',
            'phone': '020-12345678',
            'cooperationModes': ['FOB'],
            'developmentCapacity': true,
            'monthlyCapacityRanges': 'MCR003',
            'latheQuantity': 5,
            'contactPerson': 'luffy',
            'contactPhone': '13123456789',
          },
        ],
        'products': [
          {
            'name': '春秋薄款卫衣',
            'normal': [
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548306578766&di=582a7f725bffd1d95852c70c07f8fd9c&imgtype=0&src=http%3A%2F%2Fimg009.hc360.cn%2Fg6%2FM06%2F71%2FEE%2FwKhQr1PjF5WEEgn9AAAAAJ0GDyw582.jpg'
            ],
            'price': 33.3,
          },
        ]
      },
      'orderCount':10,
      'quoteCount':5,
      'purchaseOrder': {
        'code': 'PO34938475200045',
        'status': 'WAIT_FOR_PROCESSING',
        'totalQuantity': 10,
        'totalPrice': 300,
        'creationtime': DateTime.now().toString(),
        'entries': [
          {
            'basePrice': 33.0,
            'quantity': 23,
            'totalPrice': 999.9,
            'requirementOrderCode': 'RC34938475200045',
            'product': {
              'code': 'NA89852509',
              'name': '山本风法少女长裙复古气质秋冬款2',
              'skuID': 'NA89852509',
              'thumbnail':
              'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
            },
          }
        ],
        'currentPhase': 'CUTTING'
      },
      'quoteOrder': {
        'order': {
          'code': '39492523423',
          'state': 'SELLER_SUBMITTED',
          'totalPrice': 54,
          'totalQuantity': 554,
          'creationtime': DateTime.now().toString(),
          'expectedDeliveryDate': DateTime.now().toString(),
          'requirementOrderCode': '4513516134451',
        },
        'product': {
          'name': '山本风少女长裙复古气质秋冬流行新款',
          'skuID': 'NA89852631',
          'thumbnail':
          'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg',
        },
      }
    });
    return GestureDetector(
      onTap: () {
        //TODO 工厂跳转
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuppliersDetail(supplierModel: supplierModel,isSupplier: false,),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          // margin: EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(model.profilePicture),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                      child: Center(
                        child: Text(
                          '${model.name}',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 5),
                        // color: Colors.green,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Stars(
                              size: 14,
                              color: Color.fromRGBO(255, 183, 0, 1),
                              highlightOnly: false,
                              starLevel: model.starLevel,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: _buildCategoryTags(),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Text(
                          model.describe,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RichText(
                            text: TextSpan(
                                text: '历史接单',
                                style: TextStyle(color: Colors.grey),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '${model.historyOrdersCount}',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: '单')
                                ]),
                          ),
                          _buildButton()
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey[300], width: 0.6))),
        ),
      ),
    );
  }

  Widget _buildCategoryTags() {
    //取前3条
    var tags = <CategoryTag>[];
    for (int i = 0; i < model.categories.length && i < 3; i++) {
      tags.add(CategoryTag(label: model.categories[i].name));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: tags,
    );
  }

  Widget _buildButton() {
    if (showButton) {
      if (hasInvited) {
        return Container(
          height: 23,
          width: 80,
          child: Center(
            child: Text(
              '已邀请',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(20)),
        );
      } else {
        return Container(
          height: 23,
          width: 80,
          child: FlatButton(
            onPressed: () {},
            color: Colors.orange,
            child: Text(
              '邀请报价',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        );
      }
    } else {
      return Container();
    }
  }
}

class CategoryTag extends StatelessWidget {
  const CategoryTag(
      {Key key,
      this.width = 32,
      this.height = 20,
      @required this.label,
      this.color = const Color.fromRGBO(244, 143, 177, 1.0),
      this.backgroundColor = const Color.fromRGBO(248, 187, 208, 0.3)})
      : super(key: key);

  final double width;
  final double height;
  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: color, fontSize: 14),
        ),
      ),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(2)),
    );
  }
}
