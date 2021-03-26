import 'package:b2b_commerce/src/_shared/users/brand_index_search_delegate_page.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_staggered_grid.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import '../_shared/shares.dart';
import '../common/app_keys.dart';
import '_shared/widgets/banner.dart';
import '_shared/widgets/brand_section.dart';
import '_shared/widgets/factory_section.dart';
import '_shared/widgets/location.dart';
import 'factory/factory_list_v2.dart';
import 'home_appbar.dart';
import 'product/order_product_grid.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key, this.userType}) : super(key: AppKeys.homePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[
      BrandButtonsSection(),
      // HomeReportSection(),
      BrandEntranceSection(),
      // HomeEntrance()
      // ProductsSection(),
      // FactoryTabSection(),
      // MoreFactorySection()
    ],
    UserType.FACTORY: <Widget>[
      FactoryButtonsSection(),
      // HomeReportSection(),
      FactoryEntranceSection(),
      // HomeEntrance()
      // RequirementTabSection(),
      // MoreRequirementSection()
    ]
  };

  final Map<UserType, Widget> searchInputWidgets = <UserType, Widget>{
    UserType.BRAND: GlobalSearchInput<String>(
      tips: ' 找工厂、找款式...',
      delegate: BrandIndexSearchDelegatePage(),
    ),
    UserType.FACTORY: GlobalSearchInput<RequirementOrderModel>(
      tips: ' 找需求...',
      delegate: RequirementOrderSearchDelegatePage(),
    ),
  };

  get widgetsByUserType => widgets[userType];

  get searchInputWidgetsByUserType => searchInputWidgets[userType];

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
    AppVersionHelper appVersionHelper = Provider.of<AppVersionHelper>(context);
    bool isNew = await appVersionHelper.checkVersion(
        context, AppBLoC.instance.packageInfo.version, 'nbyjy');

    CertificationStatusHelper helper =
        Provider.of<CertificationStatusHelper>(context);

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
          ChangeNotifierProvider(create: (_) => FactoriesState()),
          ChangeNotifierProvider(create: (_) => ProductState()),
        ],
        child: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          child: NestedScrollView(
              key: homePageKey,
              headerSliverBuilder: _slverBuilder,
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: RequirementStaggeredGrid(),
                  ),
                  FactoryList(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ProductStaggeredGrid(),
                  ),
                ],
              )),
        ));
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverAppBar(
        expandedHeight: 188.0,
        pinned: true,
        elevation: 0.5,
        title: HomeTitle(
          leading: widget.searchInputWidgetsByUserType,
        ),
        backgroundColor: Constants.THEME_COLOR_MAIN,
        brightness: Brightness.dark,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              UserBLoC.instance.currentUser.type == UserType.BRAND
                  ? HomeBrandBannerSection()
                  : HomeFactoryBannerSection(),
            ],
          ),
        ),
      ),
      SliverList(delegate: SliverChildListDelegate(widget.widgetsByUserType)),
      SliverPersistentHeader(
          pinned: true,
          delegate: HomeAppBarDelegate(TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            tabs: <Widget>[
              Tab(
                text: "需求",
              ),
              Tab(
                text: "工厂",
              ),
              Tab(
                text: "看款",
              ),
            ],
          ))),
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
