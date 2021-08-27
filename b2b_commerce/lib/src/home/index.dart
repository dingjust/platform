import 'package:b2b_commerce/src/business/orders/requirement/requirement_list.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/common/qr_scan_page.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/search/home_search_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_keys.dart';
import '_shared/widgets/banner.dart';
import '_shared/widgets/broadcast.dart';
import '_shared/widgets/home_section.dart';
import '_shared/widgets/location.dart';
import 'home_appbar.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({
    Key key,
  }) : super(key: AppKeys.homePage);

  ///头部
  final List<Widget> _headWidgets = [
    HomeBtnsSection(),
    _HomePoster(),
    Container(
      margin: EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: HomeBroadcast(),
    )
  ];

  ///tab
  final List<Widget> _tabs = <Widget>[
    Tab(
      text: "全部需求",
    ),
    Tab(
      text: "找工厂",
    ),
    Tab(
      text: "抢订单",
    )
  ];

  ///tab
  final List<Widget> _tabBarViews = [
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: RequirementList<RequirementState>(),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: RequirementList<OrderRequirementState>(),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: RequirementList<FactoryRequirementState>(),
    ),
  ];

  ///头部
  get headWidgets => _headWidgets;

  ///搜索栏
  get searchInputWidget => HomeSearchBar();

  get tabs => _tabs;

  get tabBarViews => _tabBarViews;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey homePageKey = GlobalKey();
  TabController _tabController;
  ScrollController _scrollController;
  bool lastStatus = false;

  _HomePageState();

  List<Color> gradientColors = [Color(0xFF489BFF), Color(0x001460BA)];

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    MessageBLoC.instance.snackMessageStream.listen((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$value'),
      ));
    });
    // ns$.init(context);

    ///获取未读消息数
    notificationsPool$.checkUnread();
    WidgetsBinding.instance.addPostFrameCallback((_) => homeInit());
    super.initState();
  }

  void homeInit() async {
    AppVersionHelper appVersionHelper =
        Provider.of<AppVersionHelper>(context, listen: false);
    bool isNew = await appVersionHelper.checkVersion(
        context, AppBLoC.instance?.packageInfo?.version, 'nbyjy');

    CertificationStatusHelper helper =
        Provider.of<CertificationStatusHelper>(context, listen: false);

    //isNew为false 则弹出更新提示框，此时不弹出认证信息弹窗
    if (!helper.hasInfoValidate && isNew ?? true) {
      //认证校验
      helper.checkCertificationStatus(context);
      helper.hasInfoValidate = true;
    }

    //活动弹窗
    // ActivityHelper.instance.showActivity(context);
  }

  @override
  Widget build(BuildContext context) {
    ///极光初始化
    jpush$.setContext(context);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RequirementState()),
          ChangeNotifierProvider(create: (_) => FactoryRequirementState()),
          ChangeNotifierProvider(create: (_) => OrderRequirementState())
        ],
        child: Container(
          color: Color(0xffF7F7F7),
          child: NestedScrollView(
              key: homePageKey,
              headerSliverBuilder: _slverBuilder,
              controller: _scrollController,
              body: TabBarView(
                  controller: _tabController, children: widget.tabBarViews)),
        ));
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: expandedHeight,
        pinned: true,
        elevation: 0.5,
        title: HomeTitle(
          leading: widget.searchInputWidget,
        ),
        backgroundColor: lastStatus ? Colors.white : Color(0xffF7F7F7),
        // brightness: Brightness.dark,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  // padding: EdgeInsets.only(top: bannerPadding),
                  decoration: BoxDecoration(
                      color: Color(0xffF7F7F7),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: gradientColors)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.341,
                        width: MediaQuery.of(context).size.width,
                        child: HomeBannerSection(
                          onChanged: (colors) {
                            if (colors != null && colors.isNotEmpty) {
                              setState(() {
                                gradientColors = colors;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
      SliverList(delegate: SliverChildListDelegate(widget.headWidgets)),
      SliverPersistentHeader(
        pinned: true,
        delegate: HomeAppBarDelegate(TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: B2BTabIndicator(
                borderSide: BorderSide(
              width: 6,
              color: Color(0xffFED800),
            )),
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            unselectedLabelColor: Color(0xff666666),
            labelColor: Color(0xff222222),
            unselectedLabelStyle:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            tabs: widget.tabs)),
      )
    ];
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (expandedHeight - kToolbarHeight);
  }

  ///适配expandedHeight
  double get expandedHeight {
    print(
        'asssssssasssssssssssssssssssss${MediaQuery
            .of(context)
            .padding
            .top}');
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   // return ((MediaQuery.of(context).size.width - 24) * 120) / 351 + 105 - 17;

    //   // return MediaQuery.of(context).size.width / 2.071; //2.071为UI设计上的比例
    //   // return MediaQuery.of(context).size.width * 0.483 +
    //   //     MediaQuery.of(context).padding.top; //2.071为UI设计上的比例
    //   return MediaQuery.of(context).size.width * 0.6;
    // }
    // return ((MediaQuery.of(context).size.width - 24) * 120) / 351 + 105 - 10;
    // return MediaQuery.of(context).size.width / 2.071;
    // return MediaQuery.of(context).size.width * 0.483 +
    //     MediaQuery.of(context).padding.top; //2.071为UI设计上的比例
    // return MediaQuery.of(context).size.width * 0.6;

    return (MediaQuery
        .of(context)
        .size
        .width * 0.341 +
        MediaQuery
            .of(context)
            .padding
            .top +
        17 +
        35);
  }

  ///适配banner间隔
  double get bannerPadding {
    // 0.4667为UI设计上的比例
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   return expandedHeight * 0.4667 + 17.0;
    // }
    // return expandedHeight * 0.4667;
    return MediaQuery
        .of(context)
        .padding
        .top + 44 + 17;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }
}

class HomeTitle extends StatelessWidget {
  final Widget leading;

  const HomeTitle({Key key, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 20),
            child: LocationIcon(),
          ),
          Expanded(
            flex: 1,
            child: leading,
          ),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => QrScanPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(left: 13),
                child: B2BV2Image.top_3(width: 24, height: 24),
              )),
        ],
      ),
    );
  }
}

class _HomePoster extends StatelessWidget {
  const _HomePoster({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.ROUTE_SERVICE_DELEGATION);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Image.asset(
          'temp/index/poster1.png',
          package: 'assets',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
