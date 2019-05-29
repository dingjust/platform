import 'dart:convert';

import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/orders/requirement/requirement_order_list.dart';


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
  List<String> historyKeywords;

  Widget _buildSearchButton(BuildContext context) {
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
            }
        ).then((value) {
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
                  SearchModelPage(historyKeywords: historyKeywords,
                    searchModel: SearchModel.REQUIREMENT_ORDER,),
            ),
          );
        });
      },
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


