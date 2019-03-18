import 'dart:async';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_keys.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/home_section.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:flutter/material.dart';
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
    final double _appBarHeight = 150.0;
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
              RequirementPool(),
              _buildBroadcast(),
              _buildManagement()
            ])),
          ],
        ),
      ),
    );
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
      color: Color.fromRGBO(246, 247, 249, 1),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.volume_up,
              color: Color.fromRGBO(255, 102, 102, 1),
            ),
          ),
          Text(
            '进入蕉衣请优先注册并提交认证资料',
            style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildManagement() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '协同管理',
                style: TextStyle(
                    color: Color.fromRGBO(100, 100, 100, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              Text(
                '线下订单',
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              )
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FlatButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {},
              child: Text(
                '创建线下订单',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '• 使用蕉衣APP统一管理生产订单;',
                    style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                  ),
                  Text(
                    '• 创建后生成唯一码，邀请品牌线上查看生成进度;',
                    style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                  )
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.8, color: Color.fromRGBO(200, 200, 200, 1)))),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(240, 240, 240, 1),
                borderRadius: BorderRadius.circular(20)),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入品牌发来的唯一码',
                  hintStyle: TextStyle(fontSize: 15)),
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '• 品牌已创建线下订单，直接通过唯一码导入;',
                style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              )),
        ],
      ),
    );
  }
}

class RequirementPool extends StatelessWidget {
  /// 全部需求streamController
  final StreamController _allRequirementStreamController =
      StreamController<int>.broadcast();

  /// 推荐需求streamController
  final StreamController _recommendRequirementStreamController =
      StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    //TODO调用查询需求数量接口,触发stream控制

    return Container(
      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StreamBuilder<int>(
            stream: _allRequirementStreamController.stream,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequirementPoolAllPage()));
                },
                child: Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '全部需求',
                        style: TextStyle(
                            color: Color.fromRGBO(36, 38, 41, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      RichText(
                        text: TextSpan(
                            text: '${snapshot.data}+',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 45, 45, 1),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '需求等待回复',
                                  style: TextStyle(
                                      color: Color.fromRGBO(100, 100, 100, 1)))
                            ]),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            height: 35,
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(
                        width: 1, color: Color.fromRGBO(220, 220, 220, 1)))),
          ),
          StreamBuilder<int>(
            stream: _recommendRequirementStreamController.stream,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return GestureDetector(
                onTap: () {
                  //TODO推荐需求
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequirementPoolAllPage()));
                },
                child: Container(
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
                                  fontWeight: FontWeight.w600),
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
                                    '${snapshot.data}',
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
                              TextSpan(
                                  text: '报价',
                                  style: TextStyle(
                                      color: Color.fromRGBO(255, 45, 45, 1))),
                              TextSpan(
                                  text: '的需求',
                                  style: TextStyle(
                                      color: Color.fromRGBO(100, 100, 100, 1)))
                            ]),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
