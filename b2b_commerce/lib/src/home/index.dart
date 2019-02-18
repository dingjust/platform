import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
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
    FactoryModel(
        historyOrdersCount: 214,
        name: '广州旭日1',
        starLevel: 3,
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
        name: '广州旭日0',
        starLevel: 1,
        describe: '20年经验专业生产牛仔服装，价低质优，本月剩余小量空闲产能，欢迎报价',
        profilePicture:
            'https://img.alicdn.com/imgextra/i2/50540166/TB2RBoYahOGJuJjSZFhXXav4VXa_!!0-saturn_solar.jpg_220x220.jpg_.webp',
        categories: [
          CategoryModel(name: '牛仔'),
          CategoryModel(name: '衬衫'),
          CategoryModel(name: '夹克'),
        ])
  ];

  static Color orange = Colors.orange;
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
        color: Colors.grey[200],
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: _appBarHeight,
              pinned: true,
              elevation: 0.5,
              title: HomeSearchInputBox(),
              // centerTitle: true,
              brightness: Brightness.dark,
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.only(right: 20),
                  icon: const Icon(B2BIcons.message),
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
      margin: EdgeInsets.fromLTRB(8, 2, 8, 5),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '衣报送',
            style: TextStyle(color: Colors.orange, fontSize: 16),
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
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
