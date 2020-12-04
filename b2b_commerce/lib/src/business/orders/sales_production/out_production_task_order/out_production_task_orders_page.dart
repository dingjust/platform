import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'out_production_task_orders_list.dart';

const _statuses = <EnumModel>[
  EnumModel('TO_BE_PRODUCED', '待生产'),
  EnumModel('PRODUCING', '生产中'),
  EnumModel('TO_BE_DELIVERED', '待出库'),
  EnumModel('TO_BE_RECONCILED', '待对账'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCED', '已取消')
];

/// 生产工单
class OutProductionTaskOrdersPage extends StatefulWidget {
  @override
  _OutProductionTaskOrdersPageState createState() =>
      _OutProductionTaskOrdersPageState();
}

class _OutProductionTaskOrdersPageState extends State<OutProductionTaskOrdersPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '外发生产工单';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OutProductionTaskOrdersState>(
      create: (context) => OutProductionTaskOrdersState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: DefaultTabController(
          length: _statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(_statuses, scrollable: true),
            body: TabBarView(
              children: _statuses
                  .map((status) => OutProductionTaskOrdersView(status: status))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<OutProductionTaskOrdersState>(
              builder: (context, OutProductionTaskOrdersState state, _) =>
                  SearchAppbarTitle(
                controller: controller,
                focusNode: focusNode,
                onSearch: () {
                  state.setKeyword(controller.text);
                  if (controller.text == '') {
                    setState(() {
                      isSearching = false;
                    });
                  }
                },
                onChange: (v) {
                  state.setKeyword(controller.text);
                },
              ),
            ))
        : AppBarFactory.buildDefaultAppBar('$appBarTitle',
            actions: <Widget>[_buildSearchButton()]);
  }

  Widget _buildSearchButton() {
    return IconButton(
        icon: const Icon(B2BIcons.search, size: 20),
        onPressed: () {
          setState(() {
            isSearching = true;
          });
        });
  }
}
