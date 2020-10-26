import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'external_sale_order_item.dart';

///外接订单View
class ExternalSaleOrdersView extends StatelessWidget {
  final EnumModel status;

  const ExternalSaleOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ExternalSaleOrdersList(status),
    );
  }
}

///外接订单列表
class ExternalSaleOrdersList extends StatelessWidget {
  final EnumModel status;

  ScrollController _scrollController;

  ExternalSaleOrdersList(this.status, {Key key}) : super(key: key) {
    this._scrollController = ScrollController();
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // state.loadMoreOrders(status.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ExternalSaleOrderItem(),
              ExternalSaleOrderItem(),
              ExternalSaleOrderItem(),
              ExternalSaleOrderItem(),
              ExternalSaleOrderItem()
            ]),
        onRefresh: () async {
          // state.clear();
        },
      ),
    );
  }
}
