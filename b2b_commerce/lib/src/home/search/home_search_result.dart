import 'package:b2b_commerce/src/business/orders/requirement/requirement_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/core.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'home_search_bar.dart';

class HomeSearchResultPage extends StatefulWidget {
  final String keyword;

  const HomeSearchResultPage({Key key, this.keyword}) : super(key: key);

  @override
  _HomeSearchResultPageState createState() => _HomeSearchResultPageState();
}

class _HomeSearchResultPageState extends State<HomeSearchResultPage>
    with TickerProviderStateMixin {
  GlobalKey pageKey = GlobalKey();
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            titleSpacing: 0,
            title: SearchBar(
              tips: widget.keyword,
              onTap: () {
                Navigator.of(context).pop();
              },
            )),
        body: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) =>
                      FactoryRequirementState(keyword: widget.keyword)),
              ChangeNotifierProvider(
                  create: (_) => OrderRequirementState(keyword: widget.keyword))
            ],
            child: Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: NestedScrollView(
                  key: pageKey,
                  headerSliverBuilder: _slverBuilder,
                  body: TabBarView(controller: _tabController, children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: RequirementList<FactoryRequirementState>(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: RequirementList<OrderRequirementState>(),
                    )
                  ])),
            )));
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverPersistentHeader(
          pinned: true,
          delegate: SearchResultDelegate(TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Constants.THEME_COLOR_ORANGE,
              indicator: B2BTabIndicator(
                  yPadding: 0,
                  borderSide: BorderSide(
                    width: 6,
                    color: Color(0xffFED800),
                  )),
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              unselectedLabelColor: Color(0xff666666),
              labelColor: Color(0xff222222),
              unselectedLabelStyle:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              tabs: [Tab(text: "找工厂"), Tab(text: "抢订单")]))),
    ];
  }
}

class SearchResultDelegate extends SliverPersistentHeaderDelegate {
  SearchResultDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(child: _tabBar, color: Colors.white);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
