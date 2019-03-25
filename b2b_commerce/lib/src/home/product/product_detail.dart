import 'package:b2b_commerce/src/business/products/apparel_product_size_stock_item.dart';
import 'package:b2b_commerce/src/business/supplier/suppliers_detail.dart';
import 'package:b2b_commerce/src/home/product/product_color_size_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({Key key, @required this.productCode})
      : super(key: key);

  final String productCode;

  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
        url:
            'https://img.alicdn.com/imgextra/i2/29473371/O1CN018iO48c1alxcrQ5TCo_!!0-saturn_solar.jpg_220x220.jpg_.webp'),
    MediaModel(
      url:
          'https://img.alicdn.com/imgextra/i1/772352038/O1CN01Tg40Eb1QvRfVPq2Me_!!772352038.jpg',
    ),
    MediaModel(
      url:
          'https://img.alicdn.com/imgextra/i4/772352038/O1CN01g4qsIq1QvRfTWbVBE_!!772352038.jpg',
    ),
    MediaModel(
        url:
            'https://img.alicdn.com/imgextra/i1/772352038/O1CN01S9gNeK1QvRfV9E3c8_!!772352038.jpg'),
    MediaModel(
        url:
            'https://img.alicdn.com/imgextra/i2/772352038/O1CN01zdkaHt1QvRfUl0KDV_!!772352038.jpg')
  ];
  final List<ColorSelectEntry> colorEntries = [];
  final List<SizeSelectEntry> sizeEntries = [];
  Map<ColorSelectEntry, List<SizeStockItem>> apparelProductStockInputItems =
      Map<ColorSelectEntry, List<SizeStockItem>>();

  //TODO 根据code查询款式详情
  final product = ApparelProductModel(
      name: '冬季女棉服',
//      thumbnail:
//          'https://img.alicdn.com/imgextra/i4/311670094/O1CN014LCreL1CZ5iva14YN_!!0-saturn_solar.jpg_220x220.jpg_.webp',
      minPrice: 99.00,
      maxPrice: 500.00,
      belongTo: FactoryModel.fromJson({
        'profilePicture': {
          'profilePicture':
              'http://img.jf258.com/uploads/2015-05-14/030643325.jpg'
        },
        'uid': 'BB123456',
        'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
            'name': '森马',
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
              {
                'url':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
              },
              {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              {
                'url':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
              },
              {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              {
                'url':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
              },
              {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              {
                'url':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
              },
              {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
            ],
            'price': 33.3,
          },
          {
            'name': '春秋薄款卫衣',
            'normal': [
              {
                'url':
                    'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'
              },
              {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
            ],
            'price': 33.3,
          },
        ]
      }));

  //TODO 对应产品的颜色尺码数据
  List<ColorModel> mockColors = <ColorModel>[
    ColorModel(code: 'C01', name: '红色', colorCode: 'FF0033'),
    ColorModel(code: 'C02', name: '黄色', colorCode: 'FFCC00'),
    ColorModel(code: 'C03', name: '粉红', colorCode: 'FF9999'),
    ColorModel(code: 'C04', name: '海军蓝', colorCode: '0066FF'),
    ColorModel(code: 'C05', name: '浅紫', colorCode: 'CC99CC'),
    ColorModel(code: 'C06', name: '藏青', colorCode: '000033'),
  ];

  List<SizeModel> mockSizes = <SizeModel>[
    SizeModel(code: 'S01', name: 'XXXL'),
    SizeModel(code: 'S02', name: 'XXL'),
    SizeModel(code: 'S03', name: 'XL'),
    SizeModel(code: 'S04', name: 'L'),
    SizeModel(code: 'S05', name: 'M'),
    SizeModel(code: 'S06', name: 'S'),
    SizeModel(code: 'S07', name: 'XS')
  ];

  void initState() {
    super.initState();
    colorEntries.clear();
    sizeEntries.clear();
    apparelProductStockInputItems.clear();

    ///构建颜色尺码选中数据列
    colorEntries.addAll(mockColors
        .map((color) => ColorSelectEntry(colorModel: color))
        .toList());

    sizeEntries.addAll(
        mockSizes.map((size) => SizeSelectEntry(sizeModel: size)).toList());

    ///构建数量控制列
    colorEntries.forEach((color) {
      apparelProductStockInputItems[color] = sizeEntries
          .map((size) => SizeStockItem(size: size.sizeModel, selectEntry: size))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('现款详情'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              B2BIcons.more,
              size: 4,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(248, 248, 248, 1),
        child: ListView(
          children: <Widget>[
            ProductCarousel(items, 300),
            _buildHeaderSection(),
            _buildBasicInfoSection(),
            _buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    //因字符样式不同，将价格按小数点分割
    List<String> _minPrice = product.minPrice.toString().split(".");
    List<String> _maxPrice = product.maxPrice.toString().split(".");

    return Container(
      height: 110,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${product.name}',
            style: TextStyle(
                color: Color.fromRGBO(50, 50, 50, 1),
                fontSize: 16,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip,
          ),
          RichText(
            text: TextSpan(
                text: '￥',
                style: TextStyle(
                    color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
                children: <TextSpan>[
                  TextSpan(
                      text: '${_minPrice[0]}.', style: TextStyle(fontSize: 25)),
                  TextSpan(text: '${_minPrice[1]}'),
                  TextSpan(text: '——￥'),
                  TextSpan(
                      text: '${_maxPrice[0]}.', style: TextStyle(fontSize: 25)),
                  TextSpan(text: '${_maxPrice[1]}')
                ]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '订单数：68',
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
              ),
              Text(
                '${product.belongTo.address}',
                style: TextStyle(
                    color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      height: 100,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BasicInfoRow(
            label: '工厂',
            value: '${product.belongTo.name}',
            action: JumpTo(
              label: '进厂',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuppliersDetail(
                          supplierModel: SupplierModel(
                            factory: product.belongTo,
                          ),
                          isSupplier: false,
                        ),
                  ),
                );
              },
            ),
          ),
          BasicInfoRow(
            label: '生产周期',
            value: '220件/天',
          ),
          BasicInfoRow(
            label: '参数',
            value: '面料、含量、风格...',
            onTap: onAttribute,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: onOrder,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 150),
              child: Text(
                '下单',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 20),
              )),
        ],
      ),
    );
  }

  ///构建
  initColorSizeSelectData() {}

  void onOrder() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('填写需求信息'),
          content: Container(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('需求数量'),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(200, 200, 200, 1)))),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    // controller: _unitPriceController,
                    onChanged: (value) {},
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        hintText: '填写', border: InputBorder.none),
                  ),
                ),
                Text('备注'),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 0.5,
                              color: Color.fromRGBO(200, 200, 200, 1)))),
                  child: TextField(
                    autofocus: true,
                    // controller: _unitPriceController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        hintText: '请填写颜色、尺码、特殊工艺以及其他要求',
                        border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () async {},
            ),
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onAttribute() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return AttributeTable(
            attributes:
                ApparelProductAttributesModel(fabricComposition: 'asdadasd'),
          );
        });
  }
}

class BasicInfoRow extends StatelessWidget {
  const BasicInfoRow(
      {Key key,
      @required this.label,
      @required this.value,
      this.action,
      this.onTap})
      : super(key: key);

  final String label;
  final String value;
  final Widget action;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 80,
                  child: Text(
                    '${label}',
                    style: TextStyle(
                        color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    '${value}',
                    style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1), fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 50,
            child: action,
          )
        ],
      ),
    );
  }
}

class JumpTo extends StatelessWidget {
  const JumpTo({Key key, @required this.label, @required this.onTap})
      : super(key: key);

  final String label;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text(
                '${label}',
                style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
              ),
            ),
            Icon(
              B2BIcons.right,
              size: 12,
              color: Color.fromRGBO(255, 149, 22, 1),
            )
          ],
        ),
      ),
    );
  }
}
