import 'package:b2b_commerce/src/business/products/product_category.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/production/production_offline_order_from.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 网站主页
class HomePage extends StatefulWidget {
  HomePage() : super(key: AppKeys.homePage);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //TODO:调用接口查询推荐工厂,mock数据待删除
  static Color orange = Color.fromRGBO(255, 214, 12, 1);
  static Color white = Colors.white;

  ///图标颜色
  Color iconColor = white;

  TextEditingController _uniqueCodeTextController = TextEditingController();

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
              actions: <Widget>[
                // IconButton(
                //   padding: EdgeInsets.only(right: 20),
                //   icon: const Icon(B2BIcons.message),
                //   color: iconColor,
                //   tooltip: 'message',
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => MyClientServicesPage(),
                //       ),
                //     );
                //   },
                // ),
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
                height: 90,
                dataList: _gridItemList(),
              ),
              HomeTabSection(
                height: 100,
              ),
              _buildBroadcast(),
              FastPublishRequirement(),
              _buildSpacing(15),
              _buildTrackingProgress(),
              _buildSpacing(40),
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
          onPressed: () async {
            //加载条
            showDialog(
                context: context,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
            await ProductRepositoryImpl()
                .cascadedCategories()
                .then((categorys) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategorySelectPage(
                        minCategorySelect: [],
                        categorys: categorys,
                        categoryActionType: CategoryActionType.TO_FACTORIES,
                      )));
            });
          },
          pic: B2BImage.fast_factory(width: 60, height: 80)),
      GridItem(
          title: '看款下单',
          onPressed: () async {
            //加载条
            showDialog(
                context: context,
                child: Center(
                  child: CircularProgressIndicator(),
                ));
            await ProductRepositoryImpl()
                .cascadedCategories()
                .then((categorys) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategorySelectPage(
                        minCategorySelect: [],
                        categorys: categorys,
                        categoryActionType: CategoryActionType.TO_PRODUCTS,
                      )));
            });
          },
          pic: B2BImage.order(width: 60, height: 80)),
      // GridItem(
      //     title: '空闲产能',
      //     onPressed: () {},
      //     pic: B2BImage.idle_capacity(width: 60, height: 80)),
      // GridItem(
      //     title: '电商找厂',
      //     onPressed: () {},
      //     pic: B2BImage.find_factory(width: 60, height: 60)),
    ];
  }

  Widget _buildSpacing(double height) {
    return Container(
      color: Color.fromRGBO(246, 247, 249, 1),
      height: height,
    );
  }

  Widget _buildBroadcast() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      color: Color.fromRGBO(254, 252, 235, 1),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.volume_up,
              color: Color.fromRGBO(247, 114, 47, 1),
            ),
          ),
          Text(
            '进入蕉衣请优先注册并提交认证资料',
            style: TextStyle(color: Color.fromRGBO(247, 114, 47, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingProgress() {
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
                    fontWeight: FontWeight.w500),
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
                decoration: BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 1),
                    borderRadius: BorderRadius.circular(20)),
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
              Navigator.push(
                  context,MaterialPageRoute(
                  builder: (context) =>
                      ProductionOfflineOrder()
              )
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '没有唯一码？点击这里',
                  style: TextStyle(
                      color: Color.fromRGBO(180, 180, 180, 1), fontSize: 15),
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
