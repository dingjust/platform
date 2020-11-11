import 'package:b2b_commerce/src/business/orders/sales_production/production_task_order/production_task_order_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionTaskOrdersSelectView extends StatelessWidget {
  final EnumModel status;

  final List<ProductionTaskOrderModel> data;

  final ValueChanged<ProductionTaskOrderModel> onItemTap;

  const ProductionTaskOrdersSelectView(
      {Key key, this.status, this.data, this.onItemTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductionTaskOrdersState>(
      builder: (context, ProductionTaskOrdersState state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? ProductionTaskOrdersSelectList(
                state: state, status: status, data: data, onItemTap: onItemTap)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ProductionTaskOrdersSelectList extends StatelessWidget {
  final EnumModel status;

  final ProductionTaskOrdersState state;
  final List<ProductionTaskOrderModel> data;

  final ValueChanged<ProductionTaskOrderModel> onItemTap;

  ScrollController _scrollController;

  ProductionTaskOrdersSelectList(
      {Key key, this.status, this.state, this.data, this.onItemTap})
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
                        .map((model) => ProductionTaskOrderItem(
                              model,
                              isSelectList: true,
                              isSelected: data.any((element) => element.id == model.id),
                              onPressed: () {
                                if (onItemTap != null) {
                                  onItemTap(model);
                                }
                              },
                            ))
                        .toList(),
                  )
                : NoDataInfoRow(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: state.loadingMore ? 1.0 : 0),
            _buildEnd(),
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
