import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductionUniqueCodePage extends StatefulWidget {
  final ApparelProductModel product;

  ProductionUniqueCodePage({this.product});

  _ProductionUniqueCodePageState createState() =>
      _ProductionUniqueCodePageState();
}

class _ProductionUniqueCodePageState extends State<ProductionUniqueCodePage> {
  TextEditingController _textEditingController = TextEditingController();

  // mock数据，待删除
  PurchaseOrderModel mockData = PurchaseOrderModel.fromJson({
    'code': 'PO34938475200045',
    'status': 'IN_PRODUCTION',
    'totalQuantity': 10,
    'totalPrice': 300,
    'creationtime': DateTime.now().millisecondsSinceEpoch,
    'expectedDeliveryDate': DateTime.now().millisecondsSinceEpoch,
    'currentPhase': 'CUTTING',
    'machiningType': 'LABOR_AND_MATERIAL',
    'invoiceNeeded': true,
    'attachments': [
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg'
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg'
      },
      {
        'url':
            'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
        'mediaType': 'jpg'
      },
    ],
    'remarks': '延期了12天',
    'belongTo': {
      'name': '京东工厂',
      'address': '广东省广州市白云区',
    },
    'productionProgresses': [
      {
        'phase': 'MATERIAL_PREPARATION',
        'quantity': 70,
        'sequence': 0,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
      {
        'phase': 'CUTTING',
        'quantity': 70,
        'sequence': 2,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
      {
        'phase': 'STITCHING',
        'quantity': 70,
        'sequence': 3,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
      {
        'phase': 'AFTER_FINISHING',
        'quantity': 70,
        'sequence': 1,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
      {
        'phase': 'INSPECTION',
        'quantity': 70,
        'sequence': 4,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
      {
        'phase': 'DELIVERY',
        'quantity': 70,
        'sequence': 5,
        'estimatedDate': DateTime.now().millisecondsSinceEpoch,
        'finishDate': DateTime.now().millisecondsSinceEpoch,
        'remarks': '延期了12天',
        'medias': [
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
          {
            'url':
                'https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg',
            'mediaType': 'jpg'
          },
        ],
      },
    ],
    'deliveryAddress': {
      'fullname': "张三",
      'cellphone': '13123456789',
      'region': {'isocode': 'R123', 'name': '广东省'},
      'city': {'code': 'C123', 'name': '广州市'},
      'cityDistrict': {'code': 'D123', 'name': '海珠区'},
      'line1': '广州大道',
      'defaultAddress': true
    },
    'entries': [
      {
        'basePrice': 33.0,
        'quantity': 23,
        'totalPrice': 999.9,
        'requirementOrderCode': 'RC34938475200045',
        'code': 'NA89852509',
        'name': '山本风法少女长裙复古气质秋冬款',
        'skuID': 'NA89852509',
        'thumbnail':
        'http://dingyue.nosdn.127.net/ZsKn=CkHLVpuKgUT6wW5uRECVu0=RSGVwrKTeNjszUCdk1538637061484compressflag.jpg'
      }
    ],
  });

  PurchaseOrderModel uniqueCodeEntry;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('导入唯一码'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
        ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '请输入唯一码',
                          style: TextStyle(
                              color: Color.fromRGBO(100, 100, 100, 1),
                              fontSize: 18),
                        ),
                        TextField(
                          autofocus: true,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                uniqueCodeEntry = mockData;
                              });
                            },
                            child: Text(
                              '检索',
                              style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
                            ),
                          )),
                        )
                      ],
                    ),
                  ),
                  uniqueCodeEntry == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '唯一码对应订单信息',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                              UniqueCodeItem(
                                order: uniqueCodeEntry,
                              )
                            ],
                          ),
                        ),
                ],
              ),
              uniqueCodeEntry == null
                  ? Container()
                  : Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 40),
                      child: FlatButton(
                        color: Color(0xFFFF9516),
                        child: Text(
                          '确定导入',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        onPressed: () {},
                      ),
                    ),
            ],
          ),
        ));
  }
}

class UniqueCodeItem extends StatelessWidget {
  const UniqueCodeItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  // 订单渠道类型
  // static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
  //   RequirementOrderStatus.PENDING_QUOTE: Colors.green,
  //   RequirementOrderStatus.COMPLETED: Color.fromRGBO(255,214,12, 1),
  //   RequirementOrderStatus.CANCELLED: Colors.red
  // };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => PurchaseOrderDetailPage(order: order),
        //   ),
        // );
      },
      child: Container(
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '工厂：' + order.belongTo.name,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              // TODO : 订单类型枚举和对应颜色
              // Text(
              //   RequirementOrderStatusLocalizedMap[order.status],
              //   style: TextStyle(color: _statusColors[order.status])
              // )
              Text(
                '生产中',
                style: TextStyle(
                    color: Color.fromRGBO(86, 194, 117, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              color: Color.fromRGBO(250, 250, 250, 1),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: entry.product.thumbnail != null
                              ? NetworkImage(entry.product.thumbnail.url)
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
                      height: 90,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                entry.product.name,
                                style: TextStyle(fontSize: 15),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '货号：' + entry.product.skuID,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(150, 150, 150, 1)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '生产订单号：${order.code}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '报价时间：${DateFormatUtil.format(order.creationTime)}',
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 150, 150, 1),
                                  fontSize: 14,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
