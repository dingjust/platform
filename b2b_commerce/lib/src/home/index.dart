import 'package:b2b_commerce/src/business/orders/requirement/requirement_list.dart';
import 'package:b2b_commerce/src/common/qr_scan_page.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/search/home_search_bar.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../common/app_keys.dart';
import '_shared/widgets/banner.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: RequirementList<RequirementState>(),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: RequirementList<OrderRequirementState>(),
    ),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
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

  _HomePageState();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
          color: Color.fromRGBO(245, 245, 245, 1),
          child: NestedScrollView(
              key: homePageKey,
              headerSliverBuilder: _slverBuilder,
              body: TabBarView(
                  controller: _tabController, children: widget.tabBarViews)),
        ));
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: 200.0,
        pinned: true,
        elevation: 0.5,
        title: HomeTitle(
          leading: widget.searchInputWidget,
        ),
        backgroundColor: Constants.THEME_COLOR_MAIN,
        brightness: Brightness.dark,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[HomeBannerSection()],
          ),
        ),
      ),
      SliverList(delegate: SliverChildListDelegate(widget.headWidgets)),
      SliverPersistentHeader(
          pinned: true,
          delegate: HomeAppBarDelegate(TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Constants.THEME_COLOR_ORANGE,
              labelStyle: TextStyle(
                fontSize: 18,
              ),
              unselectedLabelColor: Color(0xff646464),
              labelColor: Constants.THEME_COLOR_ORANGE,
              unselectedLabelStyle: TextStyle(
                fontSize: 18,
              ),
              tabs: widget.tabs))),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => QrScanPage()));
              },
              child: Padding(
                padding: EdgeInsets.only(
                  right: 5,
                ),
                child: Icon(B2BIcons.qr_scanner, size: 25),
              )),
          Expanded(
            flex: 1,
            child: leading,
          ),
          LocationIcon()
        ],
      ),
    );
  }
}
