import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'reconciliation_orders_list.dart';

const _statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_B_SIGN', '待乙方签署'),
  EnumModel('PENDING_APPROVAL', '待审批'),
  EnumModel('PENDING_A_SIGN', '待甲方签署'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已取消'),
];

///出货单
class ReconciliationOrdersPage extends StatefulWidget {
  @override
  _ReconciliationOrdersPageState createState() =>
      _ReconciliationOrdersPageState();
}

class _ReconciliationOrdersPageState extends State<ReconciliationOrdersPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '对账单';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReconciliationOrdersState>(
      create: (context) => ReconciliationOrdersState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: DefaultTabController(
          length: _statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(_statuses, scrollable: true),
            body: TabBarView(
              children: _statuses
                  .map((status) => ReconciliationOrdersView(status: status))
                  .toList(),
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
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

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<ReconciliationOrdersState>(
              builder: (context, ReconciliationOrdersState state, _) =>
                  SearchAppbarTitle(
                controller: controller,
                focusNode: focusNode,
                hintText: '请输入单号,标题...',
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
}
