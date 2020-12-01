import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'reconciliation_order_item.dart';

///快速出货单View
class ReconciliationOrdersView extends StatelessWidget {
  final EnumModel status;

  const ReconciliationOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ReconciliationOrdersState>(
      builder: (context, ReconciliationOrdersState state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? ReconciliationOrdersList(status, state)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

///快速出货单列表
class ReconciliationOrdersList extends StatelessWidget {
  final ReconciliationOrdersState state;

  final EnumModel status;

  ScrollController _scrollController;

  ReconciliationOrdersList(
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
                          .map((model) => ReconciliationOrderItem(
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
