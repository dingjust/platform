import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'delivery_orders_list.dart';
import 'form/delivery_order_form.dart';

const _statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_RECONCILED', '待对账'),
  EnumModel('IN_RECONCILED', '对账中'),
  EnumModel('COMPLETED', '已完成'),
];

///出货单
class DeliveryOrdersPage extends StatefulWidget {
  @override
  _DeliveryOrdersPageState createState() => _DeliveryOrdersPageState();
}

class _DeliveryOrdersPageState extends State<DeliveryOrdersPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '出货单';

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeliveryOrdersState>(
      create: (context) => DeliveryOrdersState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: DefaultTabController(
          length: _statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(_statuses, scrollable: false),
            body: TabBarView(
              children: _statuses
                  .map((status) => DeliveryOrdersView(status: status))
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: _AddButton(),
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
            title: Consumer<DeliveryOrdersState>(
              builder: (context, DeliveryOrdersState state, _) =>
                  SearchAppbarTitle(
                controller: controller,
                focusNode: focusNode,
                hintText: '请输入单号...',
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

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        //出货表单
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DeliveryOrderForm()))
            .then((value) {
          if (value) {
            Provider.of<DeliveryOrdersState>(context, listen: false).clear();
          }
        });
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
