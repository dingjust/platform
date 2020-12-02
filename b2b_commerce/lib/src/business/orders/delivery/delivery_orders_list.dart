import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'delivery_order_item.dart';

///快速出货单View
class DeliveryOrdersView extends StatelessWidget {
  final EnumModel status;

  const DeliveryOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryOrdersState>(
      builder: (context, DeliveryOrdersState state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? DeliveryOrdersList(status, state)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

///快速出货单列表
class DeliveryOrdersList extends StatelessWidget {
  final DeliveryOrdersState state;

  final EnumModel status;

  ScrollController _scrollController;

  DeliveryOrdersList(
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
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              state.orders(status.code).isNotEmpty
                  ? Column(
                      children: state
                          .orders(status.code)
                          .map((model) => DeliveryOrderItem(
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
    return state.getEntry(status.code).currentPage + 1 ==
            state.getEntry(status.code).totalPages
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
