import 'package:b2b_commerce/src/_shared/users/brand_index_search_delegate_page.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/helper/app_version.dart';
import 'package:b2b_commerce/src/helper/certification_status.dart';
import 'package:b2b_commerce/src/home/_shared/widgets/factory_tab_section.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/shares.dart';
import '../common/app_keys.dart';
import '_shared/widgets/brand_section.dart';
import '_shared/widgets/factory_section.dart';
import '_shared/widgets/location.dart';
import '_shared/widgets/more_factory_section.dart';
import '_shared/widgets/more_requirement_section.dart';
import '_shared/widgets/requirement_tab_section.dart';

/// 首页
class HomePage extends StatefulWidget {
  HomePage({Key key, this.userType}) : super(key: AppKeys.homePage);

  final UserType userType;

  final Map<UserType, List<Widget>> widgets = <UserType, List<Widget>>{
    UserType.BRAND: <Widget>[
      BrandButtonsSection(),
      // HomeReportSection(),
      // BrandEntranceSection(),
      // ProductsSection(),
      FactoryTabSection(),
      MoreFactorySection()
    ],
    UserType.FACTORY: <Widget>[
      FactoryButtonsSection(),
      // HomeReportSection(),
      FactoryEntranceSection(),
      RequirementTabSection(),
      MoreRequirementSection()
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

class _HomePageState extends State<HomePage> {
  GlobalKey homePageKey = GlobalKey();

  _HomePageState();

  @override
  void initState() {
    MessageBLoC.instance.snackMessageStream.listen((value) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('$value'),
      ));
    });
    // ns$.init(context);

    ///获取未读消息数
    notificationsPool$.checkUnread();
    // 安卓端自动更新
    // TargetPlatform platform = defaultTargetPlatform;
    // if (platform != TargetPlatform.iOS) {
    WidgetsBinding.instance.addPostFrameCallback((_) => homeInit());
    // }
    super.initState();
  }

  void homeInit() async {
    //版本检查
    // bool isNew = await AppVersion(homePageKey.currentContext,
    //         ignoreVersionNotification:
    //             UserBLoC.instance.ignoreVersionNotification)
    //     .initCheckVersion(AppBLoC.instance.packageInfo.version, 'nbyjy');

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
    ScrollController _scrollController = ScrollController();

    ///极光初始化
    // jpush$.setContext(context);

    return Scaffold(
      key: homePageKey,
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
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
            SliverList(
                delegate: SliverChildListDelegate(widget.widgetsByUserType)),
          ],
        ),
      ),
    );
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

/// 首页Banner
class HomeBrandBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel(<CarouselItem>[
      CarouselItem(
        model: MediaModel(
          url: '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%9B%BE%E7%89%87.png',
        ),
      ),
      CarouselItem(
        model: MediaModel(
          url:
              '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%93%81%E7%89%8C%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
        ),
      ),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/activity/invite_activity_banner1.jpg',
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE);
          })
    ], 240);
  }
}

class HomeFactoryBannerSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Carousel(<CarouselItem>[
      CarouselItem(
        model: MediaModel(
          url: '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%9B%BE%E7%89%87.png',
        ),
      ),
      CarouselItem(
          model: MediaModel(
        url:
            '${GlobalConfigs.CDN_OSS_DOMAIN}/%E5%B7%A5%E5%8E%82%E8%BD%AE%E6%92%AD%E5%9B%BE2.png',
      )),
      CarouselItem(
          model: MediaModel(
            url:
                '${GlobalConfigs.CDN_OSS_DOMAIN}/activity/invite_activity_banner1.jpg',
          ),
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.ROUTE_ACTIVITY_INVITE);
          })
    ], 240);
  }
}
