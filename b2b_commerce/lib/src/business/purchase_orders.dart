import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:b2b_commerce/src/production/production_offline_order_from.dart';
import 'package:b2b_commerce/src/production/production_unique_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/orders/purchase/purchase_order_list.dart';

import '../production/production_search.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('WAIT_FOR_OUT_OF_STORE', '待出库'),
  EnumModel('OUT_OF_STORE', '已出库'),
];

class PurchaseOrdersPage extends StatefulWidget {
  _PurchaseOrdersPageState createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> with AutomaticKeepAliveClientMixin {
  String showText;
  String statusColor;
  String userType;

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: PurchaseOrderSearchDelegate()),
    );
  }

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if (bloc.isBrandUser) {
      userType = 'brand';
    } else {
      userType = 'factory';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
      bloc: PurchaseOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '生产订单',
          actions: <Widget>[_buildSearchButton()],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
            body: TabBarView(
              children: statuses.map((status) => PurchaseOrderList(status: status)).toList(),
            ),
          ),
        ),
//        floatingActionButton: ScrollToTopButton<PurchaseOrderBLoC>(),
        floatingActionButton: SpeedDial(
          // animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          // this is ignored if animatedIcon is non null
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '线下订单',
                style: TextStyle(color: Colors.black, fontSize: 12),
              )
            ],
          ),
          visible: true,
          curve: Curves.bounceIn,
          // overlayColor: Colors.black,
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // backgroundColor: Color.fromRGBO(255,214,12, 1),
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          children: [
            SpeedDialChild(
              child: Center(
                child: Text(
                  '唯一码',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              backgroundColor: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionUniqueCodePage(),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            SpeedDialChild(
              child: Center(
                child: Text(
                  '创建',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              backgroundColor: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductionOfflineOrder(),
                  ),
                );
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
