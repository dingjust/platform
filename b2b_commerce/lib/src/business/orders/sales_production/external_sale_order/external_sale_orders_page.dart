import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'external_sale_orders_list.dart';

const _statuses = <EnumModel>[
  EnumModel('TO_BE_ACCEPTED', '待接单/待提交'),
  EnumModel('AUDITING', '待审核'),
  EnumModel('AUDIT_REJECTED', '审核驳回'),
  EnumModel('AUDIT_PASSED', '生产中'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELED', '已取消'),
];

///外接订单
class ExternalSaleOrdersPage extends StatefulWidget {
  @override
  _ExternalSaleOrdersPageState createState() => _ExternalSaleOrdersPageState();
}

class _ExternalSaleOrdersPageState extends State<ExternalSaleOrdersPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '外接订单';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExternalSaleOrdersState>(
      create: (context) => ExternalSaleOrdersState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: DefaultTabController(
          length: _statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(_statuses, scrollable: true),
            body: TabBarView(
              children: _statuses
                  .map((status) => ExternalSaleOrdersView(status: status))
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onAdd,
          child: Icon(
            Icons.add,
            color: Colors.white,
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

  ///添加外接订单
  void _onAdd() {
    //唯一码导入
    Navigator.of(context)
        .pushNamed(AppRoutes.ROUTE_SALE_PRODUCTION_EXTERNAL_ORDERS_IMPORT)
        .then((value) {
      //TODO:刷新
    });
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<ExternalSaleOrdersState>(
              builder: (context, ExternalSaleOrdersState state, _) =>
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
}
