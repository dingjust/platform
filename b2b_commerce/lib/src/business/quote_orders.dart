import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/orders/quote/quote_list.dart';
import '../business/search/quotes_search.dart';

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

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: QuotesSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '报价管理',
          actions: <Widget>[_buildSearchButton(context)],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses),
            body: TabBarView(
              children: statuses
                  .map(
                    (status) => QuoteList(status: status),
                  )
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}
