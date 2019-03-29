import 'package:b2b_commerce/src/_shared/widgets/broadcast.dart';
import 'package:b2b_commerce/src/common/find_factory_by_map.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/factory/industrial_cluster_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../business/products/product_category.dart';
import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../home/home_section.dart';
import '../home/requirement/fast_publish_requirement.dart';
import '../production/production_offline_order_from.dart';
import '../production/production_unique_code.dart';

/// 网站主页 - 品牌
class BrandHomePage extends StatefulWidget {
  BrandHomePage() : super(key: AppKeys.homePage);

  @override
  _BrandHomePageState createState() => new _BrandHomePageState();
}

class _BrandHomePageState extends State<BrandHomePage> {
  //TODO:调用接口查询推荐工厂,mock数据待删除
  static Color orange = Color.fromRGBO(255, 214, 12, 1);
  static Color white = Colors.white;

  ///图标颜色
  Color iconColor = white;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double _appBarHeight = 188.0;
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
        color: Colors.white,
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
              brightness: Brightness.dark,
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
                FirstMenuSection(),
                SecondMenuSection(),
                BroadcastSection(),
                FastPublishRequirement(),
                DividerFactory.buildDivider(15),
                TrackingProgressSection(),
                DividerFactory.buildDivider(40),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// 首页Tab部分1
class FirstMenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<GridItem> items = <GridItem>[
      GridItem(
          title: '快反工厂',
          onPressed: () async {
            // 加载条
            showDialog(
              context: context,
              builder: (context) => ProgressIndicatorFactory.buildDefaultProgressIndicator(),
            );
            await ProductRepositoryImpl().cascadedCategories().then((categories) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategorySelectPage(
                        minCategorySelect: [],
                        categorys: categories,
                        categoryActionType: CategoryActionType.TO_FACTORIES,
                      ),
                ),
              );
            });
          },
          icon: B2BImage.fast_factory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () async {
            // 加载条
            showDialog(
              context: context,
              builder: (context) => ProgressIndicatorFactory.buildDefaultProgressIndicator(),
            );
            await ProductRepositoryImpl().cascadedCategories().then((categories) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategorySelectPage(
                        minCategorySelect: [],
                        categorys: categories,
                        categoryActionType: CategoryActionType.TO_PRODUCTS,
                      ),
                ),
              );
            });
          },
          icon: B2BImage.order(width: 60, height: 80)),
    ];

    return EasyGrid(items: items);
  }
}

/// 首页Tab部分2
class SecondMenuSection extends StatelessWidget {
  const SecondMenuSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> iconList = <Widget>[
      AdvanceIconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FindFactoryByMap()),
          );
        },
        title: '地图找厂',
        isHot: true,
        icon: Icon(
          B2BIcons.factory_map,
          color: Color.fromRGBO(97, 164, 251, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () async {
          List<LabelModel> labels = await UserRepositoryImpl().industrialClustersFromLabels();

          Navigator.push(context, MaterialPageRoute(builder: (context) => IndustrialClusterPage(labels)));
        },
        title: '产业集群',
        icon: Icon(
          B2BIcons.industrial_cluster,
          color: Color.fromRGBO(5, 202, 150, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FactoryPage(
                    FactoryCondition(starLevel: 0, adeptAtCategory: []),
                    route: '品牌工厂',
                  )));
        },
        title: '品牌工厂',
        icon: Icon(
          B2BIcons.factory_brand,
          color: Color.fromRGBO(255, 189, 82, 1.0),
          size: 30,
        ),
      ),
      AdvanceIconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FactoryPage(
                      FactoryCondition(starLevel: 0, adeptAtCategory: []),
                      route: '全部工厂',
                    )),
          );
        },
        title: '全部工厂',
        icon: Icon(
          B2BIcons.factory_all,
          color: Color.fromRGBO(148, 161, 246, 1.0),
          size: 30,
        ),
      )
    ];

    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: iconList,
        ),
      ),
    );
  }
}

/// 广播部分
class BroadcastSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BroadcastFactory.buildBroadcast('进入钉单请优先注册并提交认证资料');
  }
}

/// 跟踪进度版块
class TrackingProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '跟踪进度',
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromRGBO(100, 100, 100, 1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '线下订单',
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromRGBO(150, 150, 150, 1),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductionUniqueCodePage(),
                ),
              );
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Color.fromRGBO(248, 248, 248, 1), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: <Widget>[
                    Text(
                      '请输入工厂发来的唯一码',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    )
                  ],
                )),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionOfflineOrder()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '没有唯一码？点击这里',
                  style: TextStyle(color: Color.fromRGBO(180, 180, 180, 1), fontSize: 15),
                ),
                Icon(
                  B2BIcons.arrow_right,
                  color: Color.fromRGBO(180, 180, 180, 1),
                  size: 12,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
