import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/factory/quick_reaction_factory.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
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
  //TODO:调用接口查询推荐工厂
  List<FactoryModel> factories = <FactoryModel>[
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日4',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日3',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日2',
        starLevel: 4,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ]),
  ];

  static Color black = Colors.black;
  static Color white = Colors.white;

  ///图标颜色
  Color iconColor = white;

  @override
  Widget build(BuildContext context) {
    final double _appBarHeight = 200.0;
    ScrollController _scrollController = ScrollController();

    // 监听滚动变化该表图标颜色, _appBarHeight - kToolbarHeight为顶部标题栏底部与轮播图底部之间高度
    _scrollController.addListener(() {
      if (_scrollController.position.pixels < _appBarHeight - kToolbarHeight) {
        if (iconColor == black) {
          setState(() {
            iconColor = white;
          });
        }
      } else {
        if (iconColor == white) {
          setState(() {
            iconColor = black;
          });
        }
      }
    });

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              elevation: 0.5,
              title: HomeSearchInputBox(),
              centerTitle: true,
              brightness: Brightness.dark,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.message),
                  color: iconColor,
                  tooltip: 'message',
                  onPressed: () {},
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
                height: 190,
                dataList: _gridItemList(),
              ),
              _buildInfoSection(),
              HomeTabSection(
                height: 150,
              ),
              RaisedButton(
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => QuickReactionFactoryPage()));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PublishRequirementSuccessDialog(
                              model: RequirementOrderModel.fromJson({
                                "code": "34938475200045",
                                "status": "PENDING_QUOTE",
                                "totalQuantity": 10,
                                "totalPrice": 300,
                                "expectedDeliveryDate":
                                    DateTime.now().toString(),
                                "creationtime": DateTime.now().toString(),
                                "remarks": "确定前请先与我厂沟通好样衣事宜，谢谢",
                                "entries": [
                                  {
                                    "product": {
                                      "code": "NA89852509",
                                      "name": "山本风法少女长裙复古气质秋冬款",
                                      "skuID": "NA89852509",
                                      "majorCategory": {"name": "女装-T恤"},
                                      "supercategories": [
                                        {"name": "针织"}
                                      ],
                                      "thumbnail":
                                          "https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp",
                                    },
                                    "basePrice": 100.00,
                                    "entryNumber": 500,
                                  },
                                ],
                                "attachments": [
                                  {
                                    'url':
                                        'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                    'mediaType': 'webp'
                                  },
                                  {
                                    'url':
                                        'http://zb.guaihou.com/zdoc/03J012-2%20%E7%8E%AF%E5%A2%83%E6%99%AF%E8%A7%82--%E7%BB%BF%E5%8C%96%E7%A7%8D%E6%A4%8D%E8%AE%BE%E8%AE%A1.pdf',
                                    'mediaType': 'pdf'
                                  },
                                  {
                                    'url':
                                        'http://www.gzedu.gov.cn/gzsjyj/zsks/201901/4cbfd27ec7cf47ecb8867bad65a57040/files/ed312aa5e162435f928614b9c79d8fab.docx',
                                    'mediaType': 'docx'
                                  },
                                  {
                                    'url':
                                        'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                    'mediaType': 'webp'
                                  },
                                  {
                                    'url':
                                        'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                    'mediaType': 'webp'
                                  },
                                  {
                                    'url':
                                        'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
                                    'mediaType': 'webp'
                                  },
                                ]
                              }),
                            ),
                        fullscreenDialog: true,
                      ));
                },
                child: Text('发布需求成功'),
              ),
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
            Navigator.pushNamed(context, AppRoutes.ROUTE_HOT_CATEGORY);
          },
          pic: B2BImage.fast_factory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () {},
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
      margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '衣报送',
            style: TextStyle(color: Colors.orange, fontSize: 20),
          ),
          HomeInfoItem(
            label: '接单工厂',
            value: '566',
          ),
          HomeInfoItem(
            label: '正在报价',
            value: '376',
          ),
          HomeInfoItem(
            label: '今日成交',
            value: '106',
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
                      text: '———',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                      children: <TextSpan>[
                        TextSpan(
                            text: '工厂推荐',
                            style: TextStyle(color: Colors.black)),
                        TextSpan(text: '———')
                      ]),
                ),
              )
            ],
          ),
          Column(
            children: factories
                .map((item) => FactoryItem(
                      model: item,
                      showButton: true,
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
