import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/business/orders/requirement/requirement_list.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:core/core.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class NearbyRequirementPage extends StatefulWidget {
  const NearbyRequirementPage({
    Key key,
  }) : super(key: key);

  @override
  _NearbyRequirementPageState createState() => _NearbyRequirementPageState();
}

class _NearbyRequirementPageState extends State<NearbyRequirementPage>
    with TickerProviderStateMixin {
  GlobalKey pageKey = GlobalKey();
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => getLocation());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            automaticallyImplyLeading: true,
            title: Text('离我最近')),
        body: Consumer<AmapState>(
            builder: (context, AmapState state, _) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                          create: (_) => FactoryRequirementState(
                              latitude: state.latitude,
                              longtitude: state.longitude)),
                      ChangeNotifierProvider(
                          create: (_) => OrderRequirementState(
                              latitude: state.latitude,
                              longtitude: state.longitude))
                    ],
                    child: Container(
                      color: Color.fromRGBO(245, 245, 245, 1),
                      child: NestedScrollView(
                          key: pageKey,
                          headerSliverBuilder: _slverBuilder,
                          body:
                              TabBarView(controller: _tabController, children: [
                            RequirementList<FactoryRequirementState>(),
                            RequirementList<OrderRequirementState>(),
                          ])),
                    ))));
  }

  List<Widget> _slverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return [
      SliverPersistentHeader(
          pinned: true,
          delegate: SearchResultDelegate(TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Constants.THEME_COLOR_ORANGE,
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelColor: Color(0xff646464),
              labelColor: Constants.THEME_COLOR_ORANGE,
              unselectedLabelStyle: TextStyle(fontSize: 18),
              tabs: [Tab(text: "找工厂"), Tab(text: "抢订单")]))),
    ];
  }

  void getLocation() async {
    AmapState state = Provider.of<AmapState>(context, listen: false);

    Widget _dialog = CustomizeDialog(
      dialogType: DialogType.CONFIRM_DIALOG,
      contentText2: '钉单正在请求定位权限,请设置',
      isNeedConfirmButton: true,
      isNeedCancelButton: true,
      confirmButtonText: '去设置',
      cancelButtonText: '选择城市',
      dialogHeight: 180,
      confirmAction: () {
        state.openAppSetting().then((val) {
          Navigator.of(context).pop(val);
        });
      },
      cancelAction: () async {
        Navigator.of(context).pop();
        Tip tip = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
        List<String> locationArray = tip.location.split(',');
        //设置定位信息
        state.setAMapLocation(
            // aOIName: tip.district.,
            longitude: double.parse(locationArray[0]),
            latitude: double.parse(locationArray[1]));
      },
    );
    Provider.of<AmapState>(context, listen: false)
        .getAMapLocation(context: context, openDialog: _dialog);
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
