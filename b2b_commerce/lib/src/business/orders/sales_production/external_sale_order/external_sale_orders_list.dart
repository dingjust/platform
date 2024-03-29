import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'external_sale_order_item.dart';

///外接订单View
class ExternalSaleOrdersView extends StatelessWidget {
  final EnumModel status;

  const ExternalSaleOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExternalSaleOrdersState>(
      builder: (context, ExternalSaleOrdersState state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? ExternalSaleOrdersList(status, state)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

///外接订单列表
class ExternalSaleOrdersList extends StatelessWidget {
  final ExternalSaleOrdersState state;

  final EnumModel status;

  ScrollController _scrollController;

  ExternalSaleOrdersList(
    this.status,
    this.state, {
    Key key,
  }) : super(key: key) {
    this._scrollController = ScrollController();
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMoreOrders(status.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF7F7F7),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              state.orders(status.code).isNotEmpty
                  ? Column(
                      children: state
                          .orders(status.code)
                          .map((model) => ExternalSaleOrderItem(
                                model,
                              ))
                          .toList(),
                    )
                  : NoDataInfoRow(),
              ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: state.loadingMore ? 1.0 : 0,
              ),
              _buildEnd()
            ]),
        onRefresh: () async {
          state.clear();
        },
      ),
    );
  }

  Widget _buildEnd() {
    return state
        .getEntry(status.code)
        .currentPage + 1 ==
        state
            .getEntry(status.code)
            .totalPages
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('已经到底了')],
      ),
    )
        : Container();
  }
}
