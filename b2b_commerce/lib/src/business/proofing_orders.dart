import 'dart:convert';

import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/orders/proofing/proofing_list.dart';
import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/widgets/tab_factory.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('PENDING_DELIVERY', '待发货'),
  EnumModel('SHIPPED', '已发货'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已取消')
];

class ProofingOrdersPage extends StatefulWidget {
  _ProofingOrdersPageState createState() => _ProofingOrdersPageState();
}

class _ProofingOrdersPageState extends State<ProofingOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_ProofingOrdersPageState>();
  List<String> historyKeywords;

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack: LocalStorage.get(
                    GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
                outsideDismiss: false,
                loadingText: '加载中。。。',
                entrance: '',
              );
            }).then((value) {
          if (value != null && value != '') {
            List<dynamic> list = json.decode(value);
            historyKeywords = list.map((item) => item as String).toList();
          } else {
            historyKeywords = [];
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchModelPage(
                  searchModel: SearchModel(
                historyKeywords: historyKeywords,
                searchModelType: SearchModelType.PROOFING_ORDER,
                route: GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
              )),
            ),
          );
        });
      },
//      onPressed: () => showSearch(context: context, delegate: ProofingSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
      key: _globalKey,
      bloc: ProofingOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '打样订单管理',
          actions: <Widget>[_buildSearchButton()],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
            body: TabBarView(
              children: statuses.map((status) {
                return ProofingList(status: status);
              }).toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<ProofingOrdersBLoC>(),
      ),
    );
  }
}
