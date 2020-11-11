import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/quote/quote_my_list.dart';
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

class QuoteMyOrdersPage extends StatefulWidget {
  _QuoteMyOrdersPageState createState() => _QuoteMyOrdersPageState();
}

class _QuoteMyOrdersPageState extends State<QuoteMyOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_QuoteMyOrdersPageState>();
  List<String> historyKeywords;

  List<QuoteMyList> tabViewList = statuses
      .map(
        (status) =>
        QuoteMyList(
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
              builder: (context) =>
                  SearchModelPage(
                      searchModel: SearchModel(
                        historyKeywords: historyKeywords,
                        searchModelType: SearchModelType.QUOTE_ORDER,
                        route: GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
                      )),
            ),
          );
        });
      },
//      onPressed: () => showSearch(context: context, delegate: QuotesSearchDelegate()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    QuoteMyOrdersBLoC.instance.reset();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteMyOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteMyOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '我的报价',
          actions: <Widget>[_buildSearchButton()],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: tabBar,
            body: TabBarView(children: tabViewList),
          ),
        ),
        floatingActionButton: ScrollToTopButton<QuoteMyOrdersBLoC>(),
      ),
    );
  }
}
