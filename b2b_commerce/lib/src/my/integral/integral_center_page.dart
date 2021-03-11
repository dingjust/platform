import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'integral_activity_item.dart';
import 'integral_exchange_history.dart';
import 'integral_exchange_page.dart';
import 'integral_history.dart';
import 'integral_tab.dart';

///积分中心
class IntegralCenterPage extends StatefulWidget {
  @override
  _IntegralCenterPageState createState() => _IntegralCenterPageState();
}

class _IntegralCenterPageState extends State<IntegralCenterPage>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('积分中心'),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserIntegralHistoryState()),
            ChangeNotifierProvider(
                create: (_) => UserIntegralExchangeHistoryState()),
          ],
          child: Container(
            child: NestedScrollView(
              headerSliverBuilder: _sliverBuilder,
              body: TabBarView(controller: _tabController, children: [
                IntegralHistory(),
                IntegralExchangeHistory(),
              ]),
            ),
          ),
        ));
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverList(
          delegate: SliverChildListDelegate([
        _PointCard(),
        _IntegralActivityCard(),
        Container(
          height: 10,
        )
      ])),
      SliverPersistentHeader(
        pinned: true,
        delegate: IntegralTabBarDelegate(
            child: TabBar(
          controller: this._tabController,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            Tab(text: '积分收支明细'),
            Tab(text: '积分兑换申请'),
          ],
        )),
      ),
    ];
  }
}

///积分信息
class _PointCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFff952f),
                  Color(0xFFffdc97),
                  // Color(0xfffbd384)
                ]),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                // right: 20,
                child: Icon(
              B2BIcons.integral,
              color: Color.fromRGBO(255, 149, 47, 0.2),
              size: 100,
            )),
            Consumer<UserIntegralHistoryState>(
              builder: (context, UserIntegralHistoryState state, _) =>
                  state.integralInfo != null
                      ? Row(
                          children: [
                            _Text(
                                title: '可用积分',
                                val: state.integralInfo.availablePoints),
                            _Text(
                              title: '扣缴积分',
                              val: state.integralInfo.withholdPoints,
                            )
                          ],
                        )
                      : Row(
                          children: [
                            _Text(
                              title: '可用积分',
                              val: 0,
                            ),
                            _Text(
                              title: '扣缴积分',
                              val: 0,
                            )
                          ],
                        ),
            ),
          ],
        ));
  }
}

///积分活动
class _IntegralActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        height: 200,
        decoration: BoxDecoration(
            color: Color(0xffffeec2),
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFFfed39c), Color(0xFFfff7d8)]),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 5),
                  child: Text(
                    '积分活动',
                    style: TextStyle(color: Color(0xff935c22)),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IntegralActivityItem(
                      leading: B2BImage.luckeyMoney2(width: 50, height: 50),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => IntegralExchangePage()))
                            .then((value) {
                          if (value != null && value) {
                            refresh(context);
                          }
                        });
                      },
                      descripiton: '限时积分领红包',
                      title: '积分换红包',
                    ),
                    IntegralActivityItem(
                      leading: B2BImage.gifit(width: 50, height: 50),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE)
                            .then((value) {
                          if (value != null && value) {
                            refresh(context);
                          }
                        });
                      },
                      routeTo: AppRoutes.ROUTE_ACTIVITY_INVITE,
                      title: '邀请好友获积分',
                      descripiton: '每邀新一位好友注册获3',
                      tail: Icon(
                        B2BIcons.integral,
                        size: 12,
                        color: Color(0xfffbcf2f),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  ///刷新
  void refresh(BuildContext context) {
    Provider.of<UserIntegralHistoryState>(context).clear();
    Provider.of<UserIntegralExchangeHistoryState>(context).clear();
  }
}

class _Text extends StatelessWidget {
  final String title;

  final int val;

  const _Text({Key key, this.title, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            '$title',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '$val',
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }
}
