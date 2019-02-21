import 'package:flutter/material.dart';
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
      'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1548494182390&di=a7928c3e9b9adb28e71cd84991a28470&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01c16a59016013a80121455009859b.jpg%401280w_1l_2o_100sh.jpg',
    ),
    MediaModel(
      'http://dingjust.oss-cn-shenzhen.aliyuncs.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20190126151855.jpg',
    ),
  ];

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
          children: <Widget>[ProductCarousel(items, 300)],
        ),
      ),
    );
  }
}
