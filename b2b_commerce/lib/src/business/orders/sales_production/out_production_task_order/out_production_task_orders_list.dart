import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'out_production_task_order_item.dart';

class OutProductionTaskOrdersView extends StatelessWidget {
  final EnumModel status;

  const OutProductionTaskOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OutProductionTaskOrdersState>(
      builder: (context, OutProductionTaskOrdersState state, _) => Container(
        color: Color(0xffF7F7F7),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: state.getEntry(status.code).totalElements > -1
            ? OutProductionTaskOrdersList(state, status)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class OutProductionTaskOrdersList extends StatelessWidget {
  final EnumModel status;

  final OutProductionTaskOrdersState state;

  ScrollController _scrollController;

  OutProductionTaskOrdersList(this.state, this.status, {Key key})
      : super(key: key) {
    this._scrollController = ScrollController();
    // 监听加载更多
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
                        .map((model) => OutProductionTaskOrderItem(model))
                        .toList(),
                  )
                : NoDataInfoRow(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: state.loadingMore ? 1.0 : 0),
            _buildEnd()
          ],
        ),
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
