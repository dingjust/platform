import 'dart:convert';

import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/orders/quote/quote_list.dart';
import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/widgets/tab_factory.dart';

List<EnumModel> statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('SELLER_SUBMITTED', '待处理'),
  EnumModel('BUYER_APPROVED', '通过'),
  EnumModel('BUYER_REJECTED', '拒绝'),
];

class QuoteOrdersPage extends StatefulWidget {
  _QuoteOrdersPageState createState() => _QuoteOrdersPageState();
}

class _QuoteOrdersPageState extends State<QuoteOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_QuoteOrdersPageState>();
  List<String> historyKeywords;

  List<QuoteList> tabViewList = statuses
      .map(
        (status) =>
        QuoteList(
          status: status,
        ),
  )
      .toList();

  TabBar tabBar = TabFactory.buildDefaultTabBar(statuses);

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
                    GlobalConfigs.ORDER_PRODUCT_HISTORY_KEYWORD_KEY),
                outsideDismiss: false,
                loadingText: '加载中。。。',
                entrance: 'createPurchaseOrder',
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
              builder: (context) =>
                  SearchModelPage(
                    historyKeywords: historyKeywords,
                    searchModel: SearchModel.QUOTE_ORDER,
                  ),
            ),
          );
        });
      },
//      onPressed: () => showSearch(context: context, delegate: QuotesSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    tabViewList.forEach((item) {
      print('${item.hashCode}');
    });

    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '报价管理',
          actions: <Widget>[_buildSearchButton()],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: tabBar,
            body: TabBarView(children: tabViewList),
          ),
        ),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}
