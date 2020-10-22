import 'dart:convert';

import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_list.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('PENDING_DELIVERY', '待发货'),
  EnumModel('PENDING_CONFIRM', '待收货'),
  EnumModel('ON_RETURN', '退款/售后'),
  EnumModel('COMPLETED', '完成'),
];

class SaleOrdersPage extends StatefulWidget {
  _SaleOrdersPageState createState() => _SaleOrdersPageState();
}

class _SaleOrdersPageState extends State<SaleOrdersPage> {
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SaleOrdersState>(
      builder: (context) => SaleOrdersState(),
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar('销售订单',
            actions: <Widget>[_buildSearchButton()]),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
            body: TabBarView(
              children: statuses
                  .map((status) => SaleOrderListPage(status: status))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () async {
        String value =
            await LocalStorage.get(GlobalConfigs.SALE_HISTORY_KEYWORD_KEY);
        if (value != null && value != '') {
          List<dynamic> list = json.decode(value);
          historyKeywords = list.map((item) => item as String).toList();
        } else {
          historyKeywords = [];
        }
        _toSearchResultPage();
      },
    );
  }

  void _toSearchResultPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SearchModelPage(
              searchModel: SearchModel(
                historyKeywords: historyKeywords,
                searchModelType: SearchModelType.SALE_ORDER,
                route: GlobalConfigs.SALE_HISTORY_KEYWORD_KEY,
              ),
            ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // SaleOrderBLoC.instance.reset();
  }
}
