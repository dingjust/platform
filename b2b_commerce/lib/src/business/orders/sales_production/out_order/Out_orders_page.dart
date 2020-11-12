import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/out_order/out_orders_list.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const _statuses = <EnumModel>[
  EnumModel('TO_BE_SUBMITTED', '待提交'),
  EnumModel('AUDITING', '待审核'),
  EnumModel('AUDIT_REJECTED', '审核驳回'),
  EnumModel('TO_BE_ACCEPTED', '待接单'),
  EnumModel('AUDIT_PASSED', '生产中'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELED', '已取消'),
];

class OutOrdersPage extends StatefulWidget {
  @override
  _OutOrdersPageState createState() => _OutOrdersPageState();
}

class _OutOrdersPageState extends State<OutOrdersPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '外发订单';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OutOrdersState>(
        create: (context) => OutOrdersState(),
        child: Scaffold(
          appBar: _buildAppbar(),
          body: DefaultTabController(
              length: _statuses.length,
              child: Scaffold(
                appBar:
                    TabFactory.buildDefaultTabBar(_statuses, scrollable: true),
                body: TabBarView(
                  children: _statuses
                      .map((status) => OutOrdersView(status: status))
                      .toList(),
                ),
              )),
          floatingActionButton: _AddButton(),
        ));
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
            title: Consumer<OutOrdersState>(
                builder: (context, OutOrdersState state, _) =>
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
                    )),
    )
        : AppBarFactory.buildDefaultAppBar('$appBarTitle',
        actions: <Widget>[_buildSearchButton()]);
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //唯一码导入
        Navigator.of(context)
            .pushNamed(AppRoutes.ROUTE_OUT_ORDER_FORM)
            .then((value) {
          // if (value) {
          //   Provider.of<ExternalSaleOrdersState>(context).clear();
          // }
        });
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
