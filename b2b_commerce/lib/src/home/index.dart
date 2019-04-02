import 'dart:async';

import 'package:b2b_commerce/src/home/pool/requirement_pool_recommend.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/broadcast_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/business/product_search_input.dart';
import '../business/products/product_category.dart';
import '../common/app_image.dart';
import '../common/app_keys.dart';
import '../common/find_factory_by_map.dart';
import '../home/factory/factory_list.dart';
import '../home/factory/industrial_cluster_factory.dart';
import '../home/pool/requirement_pool_all.dart';
import '../home/requirement/fast_publish_requirement.dart';
import '../production/production_offline_order_from.dart';
import '../production/production_unique_code.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  HomePage({Key key, this.userType}) : super(key: AppKeys.homePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[
      BrandFirstMenuSection(),
      BrandSecondMenuSection(),
      BroadcastSection(),
      FastPublishRequirement(),
      DividerFactory.buildDivider(15),
      BrandTrackingProgressSection(),
      DividerFactory.buildDivider(40),
    ],
    UserType.FACTORY: <Widget>[
      FactoryRequirementPoolSection(),
      BroadcastSection(),
      FactoryCollaborationSection(),
    ]
  };

  get widgetsByUserType => widgets[userType];

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 188.0,
              pinned: true,
              elevation: 0.5,
              title: ProductSearchInput(
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
            SliverList(delegate: SliverChildListDelegate(widget.widgetsByUserType)),
          ],
        ),
      ),
    );
  }
}

/// 首页Banner
class HomeBannerSection extends StatelessWidget {
  final List<MediaModel> items = <MediaModel>[
    MediaModel(
      url: 'http://dingjust.oss-cn-shenzhen.aliyuncs.com/banner.png',
    ),
    MediaModel(
      url: 'https://dingjust.oss-cn-shenzhen.aliyuncs.com/banner2.png',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Carousel(items, 240);
  }
}

/// 品牌 - 首页Tab部分1
class BrandFirstMenuSection extends StatelessWidget {
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
                        categories: categories,
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
                        categories: categories,
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

/// 品牌 - 首页Tab部分2
class BrandSecondMenuSection extends StatelessWidget {
  const BrandSecondMenuSection({Key key}) : super(key: key);

  Widget _buildFindFactoriesByMapMenuItem(BuildContext context) {
    return AdvanceIconButton(
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
    );
  }

  Widget _buildFindFactoriesByIndustrialClusterMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () async {
        List<LabelModel> labels = await UserRepositoryImpl().industrialClustersFromLabels();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndustrialClusterPage(labels: labels),
          ),
        );
      },
      title: '产业集群',
      icon: Icon(
        B2BIcons.industrial_cluster,
        color: Color.fromRGBO(5, 202, 150, 1.0),
        size: 30,
      ),
    );
  }

  Widget _buildBrandedFactoriesMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FactoryPage(
                  FactoryCondition(starLevel: 0, adeptAtCategory: []),
                  route: '品牌工厂',
                ),
          ),
        );
      },
      title: '品牌工厂',
      icon: Icon(
        B2BIcons.factory_brand,
        color: Color.fromRGBO(255, 189, 82, 1.0),
        size: 30,
      ),
    );
  }

  Widget _buildAllFactoriesMenuItem(BuildContext context) {
    return AdvanceIconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FactoryPage(
                  FactoryCondition(starLevel: 0, adeptAtCategory: []),
                  route: '全部工厂',
                ),
          ),
        );
      },
      title: '全部工厂',
      icon: Icon(
        B2BIcons.factory_all,
        color: Color.fromRGBO(148, 161, 246, 1.0),
        size: 30,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildFindFactoriesByMapMenuItem(context),
            _buildFindFactoriesByIndustrialClusterMenuItem(context),
            _buildBrandedFactoriesMenuItem(context),
            _buildAllFactoriesMenuItem(context),
          ],
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
class BrandTrackingProgressSection extends StatelessWidget {
  Widget _buildTitle() {
    return Row(
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
    );
  }

  Widget _buildUniqueCode(BuildContext context) {
    return GestureDetector(
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
        decoration: BoxDecoration(
          color: Color.fromRGBO(248, 248, 248, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Text(
              '请输入工厂发来的唯一码',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoUniqueCode(BuildContext context) {
    return GestureDetector(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        children: <Widget>[
          _buildTitle(),
          _buildUniqueCode(context),
          _buildNoUniqueCode(context),
        ],
      ),
    );
  }
}

class FactoryRequirementPoolSection extends StatelessWidget {
  /// 全部需求streamController
  final StreamController _allRequirementStreamController = StreamController<int>.broadcast();

  /// 推荐需求streamController
  final StreamController _recommendRequirementStreamController = StreamController<int>.broadcast();

  final StreamController _reportsStreamController =
      StreamController<Reports>.broadcast();

  void queryReports() async {
    Reports response = await ReportsRepository().report();
    if (response != null) {
      _reportsStreamController.add(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    queryReports();
    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StreamBuilder<int>(
            stream: _allRequirementStreamController.stream,
            initialData: 10,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return GestureDetector(
                onTap: () async {
                  await ProductRepositoryImpl().majorCategories().then((categories) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequirementPoolAllPage(
                              categories: categories,
                            ),
                      ),
                    );
                  });
                },
                child: AllRequirementMenuItem(count: snapshot.data),
              );
            },
          ),
          DividerFactory.buildVerticalSeparator(35),
          StreamBuilder<int>(
            stream: _recommendRequirementStreamController.stream,
            initialData: 20,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return GestureDetector(
                onTap: () async{
                  await ProductRepositoryImpl().majorCategories().then((categories) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RequirementPoolRecommend(
                          categories: categories,
                        )));
                  });
                },
                child: RecommendedRequirementMenuItem(count: snapshot.data),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AllRequirementMenuItem extends StatelessWidget {
  const AllRequirementMenuItem({Key key, @required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '全部需求',
            style: TextStyle(
              color: Color.fromRGBO(36, 38, 41, 1),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          RichText(
            text: TextSpan(
              text: '$count +',
              style: TextStyle(
                color: Color.fromRGBO(255, 45, 45, 1),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '需求等待回复',
                  style: TextStyle(
                    color: Color.fromRGBO(100, 100, 100, 1),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RecommendedRequirementMenuItem extends StatelessWidget {
  const RecommendedRequirementMenuItem({Key key, @required this.count}) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Text(
                  '推荐需求',
                  style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(255, 38, 38, 1),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          RichText(
            text: TextSpan(
                text: '待我',
                style: TextStyle(
                  color: Color.fromRGBO(100, 100, 100, 1),
                ),
                children: <TextSpan>[
                  TextSpan(text: '报价', style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1))),
                  TextSpan(text: '的需求', style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)))
                ]),
          )
        ],
      ),
    );
  }
}

/// 协同管理
class FactoryCollaborationSection extends StatelessWidget {
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '协同管理',
          style: TextStyle(
            color: Color.fromRGBO(100, 100, 100, 1),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        Text(
          '线下订单',
          style: TextStyle(
            color: Color.fromRGBO(150, 150, 150, 1),
          ),
        )
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FlatButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductionOfflineOrder(),
            ),
          );
        },
        child: Text(
          '创建线下订单',
          style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCreationTips() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '• 使用钉单APP统一管理生产订单;',
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          ),
          Text(
            '• 创建后生成唯一码，邀请品牌线上查看生成进度;',
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          )
        ],
      ),
    );
  }

  Widget _buildUniqueCodeInput(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductionUniqueCodePage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(240, 240, 240, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '请输入品牌发来的唯一码',
        ),
      ),
    );
  }

  Widget _buildInputTips() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '• 品牌已创建线下订单，直接通过唯一码导入;',
        style: TextStyle(
          color: Color.fromRGBO(150, 150, 150, 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          _buildTitle(),
          _buildCreateButton(context),
          _buildCreationTips(),
          DividerFactory.buildHorizontalSeparator(10, 20),
          _buildUniqueCodeInput(context),
          _buildInputTips(),
        ],
      ),
    );
  }
}
