import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/components/production_task_orders_select_list.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 生产工单
class ProductionTaskOrdersSelectPage extends StatefulWidget {
  final List<ProductionTaskOrderModel> selected;

  const ProductionTaskOrdersSelectPage({Key key, this.selected})
      : super(key: key);

  @override
  _ProductionTaskOrdersSelectPage createState() =>
      _ProductionTaskOrdersSelectPage();
}

class _ProductionTaskOrdersSelectPage
    extends State<ProductionTaskOrdersSelectPage> {
  bool isSearching = false;
  TextEditingController controller;
  FocusNode focusNode;
  String appBarTitle = '生产工单';
  EnumModel status = new EnumModel('SELECT_LIST', '待生产');

  List<ProductionTaskOrderModel> selectedOrders;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    selectedOrders = [];
    if (widget.selected != null) {
      selectedOrders.addAll(widget.selected);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductionTaskOrdersState>(
      create: (context) => ProductionTaskOrdersState(),
      child: Scaffold(
        appBar: _buildAppbar(),
        body: ProductionTaskOrdersSelectView(
          status: status,
          data: selectedOrders,
          onItemTap: onItemTap,
        ),
        bottomNavigationBar: _buildBottom(),
      ),
    );
  }

  Widget _buildBottom() {
    return Consumer<ProductionTaskOrdersState>(
      builder: (context, ProductionTaskOrdersState state, _) => Container(
        height: 50,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                '已选择：${_selectedCode()}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
                flex: 1,
                child: FlatButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () {
                    Navigator.of(context).pop(selectedOrders);
                  },
                  child: Text(
                    '确定',
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _selectedCode() {
    if (selectedOrders.length <= 0) {
      return '';
    }
    String selectedCode =
        selectedOrders.map((order) => order.code).toList().toString();
    return selectedCode.substring(1, selectedCode.length - 1);
  }

  Widget _buildAppbar() {
    return isSearching
        ? AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            title: Consumer<ProductionTaskOrdersState>(
              builder: (context, ProductionTaskOrdersState state, _) =>
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

  void onItemTap(ProductionTaskOrderModel model) {
    setState(() {
      if (selectedOrders.any((element) => element.id == model.id)) {
        selectedOrders.removeWhere((element) => element.id == model.id);
      } else {
        selectedOrders.add(model);
      }
    });
  }
}
