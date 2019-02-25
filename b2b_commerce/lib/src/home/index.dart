import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/my/my_client_services.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  HomePage() : super(key: AppKeys.homePage);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TODO:调用接口查询推荐工厂,mock数据待删除
  Map<String, dynamic> mockFactory = {
    'profilePicture': 'http://img.jf258.com/uploads/2015-05-14/030643325.jpg',
    'uid': 'BB123456',
    'name': '草帽工厂',
    'starLevel': 5,
    'describe': '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
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
          {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
          {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
          {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
          {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
          {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
        ],
        'price': 33.3,
      },
      {
        'name': '春秋薄款卫衣',
        'normal': [
          {'url': 'http://img.alicdn.com/bao/uploaded/O1CN01lBdn6U1X6KmbjwLmM_!!595412874.jpg_80x80.jpg'},
          {'url': 'https://node.500px.me/tpl/baijia0103/imgs/shili1.jpg'},
        ],
        'price': 33.3,
      },
    ]
  };
  List<FactoryModel> factories = <FactoryModel>[];

  static Color orange = Colors.orange;
  static Color white = Colors.white;

  ///图标颜色
  Color iconColor = white;

  void initState() {
    super.initState();
    //TODO 假数据，待删除
    for (int i = 0; i < 5; i++) {
      FactoryModel factoryModel=FactoryModel.fromJson(mockFactory);
      factoryModel.name='草帽工厂${i+1}';
      factories.add(factoryModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _appBarHeight = 200.0;
    ScrollController _scrollController = ScrollController();

    // 监听滚动变化该表图标颜色, _appBarHeight - kToolbarHeight为顶部标题栏底部与轮播图底部之间高度
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < _appBarHeight - kToolbarHeight) {
        if (iconColor == orange) {
          setState(() {
            iconColor = white;
          });
        }
      } else {
        if (iconColor == white) {
          setState(() {
            iconColor = orange;
          });
        }
      }
    });

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              elevation: 0.5,
              title: HomeSearchInputBox(
                height: 35,
              ),
              // centerTitle: true,
              brightness: Brightness.dark,
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: const Icon(B2BIcons.message),
                  color: iconColor,
                  tooltip: 'message',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyClientServicesPage(),
                      ),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    HomeBannerSection(),
                  ],
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[
              EasyGrid(
                height: 163,
                dataList: _gridItemList(),
              ),
              _buildInfoSection(),
              HomeTabSection(
                height: 150,
              ),
              FastPublishRequirement(),
              _buildRecommend(),
            ])),
          ],
        ),
      ),
    );
  }

  List<GridItem> _gridItemList() {
    return [
      GridItem(
          title: '当季快反',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_HOT_CATEGORY_FACTORY);
          },
          pic: B2BImage.fast_factory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.ROUTE_HOT_CATEGORY_PRODUCT);
          },
          pic: B2BImage.order(width: 60, height: 80)),
      GridItem(
          title: '空闲产能',
          onPressed: () {},
          pic: B2BImage.idle_capacity(width: 60, height: 80)),
      GridItem(
          title: '电商找厂',
          onPressed: () {},
          pic: B2BImage.find_factory(width: 60, height: 60)),
    ];
  }

  Widget _buildInfoSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 2, 8, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '衣报送',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          HomeInfoItem(
            label: '接单工厂',
            value: '566',
            end: '家',
          ),
          HomeInfoItem(
            label: '正在报价',
            value: '376',
            end: '单',
          ),
          HomeInfoItem(
            label: '今日成交',
            value: '106',
            end: '单',
          )
        ],
      ),
    );
  }

  Widget _buildRecommend() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: RichText(
                  text: TextSpan(
                      text: '-',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '推荐工厂',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '-')
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: factories
                .map((item) => FactoryItem(
                      model: item,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
