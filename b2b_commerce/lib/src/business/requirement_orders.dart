import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/orders/requirement/requirement_order_list.dart';

import './search/requirement_order_search.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_QUOTE', '报价中'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已失效')
];

class RequirementOrdersPage extends StatefulWidget {
  _RequirementOrdersPageState createState() => _RequirementOrdersPageState();
}

class _RequirementOrdersPageState extends State<RequirementOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_RequirementOrdersPageState>();

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: RequirementOrderSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<RequirementOrderBLoC>(
      key: _globalKey,
      bloc: RequirementOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '需求订单管理',
          actions: <Widget>[_buildSearchButton(context)],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses),
            body: TabBarView(
              children: statuses
                  .map(
                    (status) => RequirementOrderList(status: status),
                  )
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<RequirementOrderBLoC>(),
      ),
    );
  }
}


