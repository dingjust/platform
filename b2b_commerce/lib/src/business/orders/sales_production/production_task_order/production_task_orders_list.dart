import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/production_task_order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionTaskOrdersView extends StatelessWidget {
  final EnumModel status;

  const ProductionTaskOrdersView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionTaskOrdersState>(
      builder: (context, ProductionTaskOrdersState state, _) => Container(
        color: Color(0xffF7F7F7),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: state.getEntry(status.code).totalElements > -1
            ? ProductionTaskOrdersList(state, status)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ProductionTaskOrdersList extends StatelessWidget {
  final EnumModel status;

  final ProductionTaskOrdersState state;

  ScrollController _scrollController;

  ProductionTaskOrdersList(this.state, this.status, {Key key})
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
                        .map((model) => ProductionTaskOrderItem(model))
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
