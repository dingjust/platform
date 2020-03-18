import 'package:b2b_commerce/src/business/orders/sale/sale_order_list_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SaleOrderListPage extends StatefulWidget {
  final EnumModel status;

  const SaleOrderListPage({Key key, this.status}) : super(key: key);

  @override
  _SaleOrderListPageState createState() => _SaleOrderListPageState();
}

class _SaleOrderListPageState extends State<SaleOrderListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<SaleOrdersState>(
      builder: (context, SaleOrdersState state, _) =>
          Container(
            child: state
                .getEntry(widget.status.code)
                .totalElements > -1
                ? SaleOrderList(
              state: state,
              status: widget.status,
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class SaleOrderList extends StatelessWidget {
  final EnumModel status;

  final SaleOrdersState state;

  final ScrollController _scrollController = ScrollController();

  SaleOrderList({
    Key key,
    this.status,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMoreOrders(status.code);
      }
    });

    return Container(
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              state
                  .orders(status.code)
                  .isNotEmpty
                  ? Column(
                children: state
                    .orders(status.code)
                    .map((model) =>
                    SaleOrderListItem(
                      model: model,
                    ))
                    .toList(),
              )
                  : _NoDataInfoRow(),
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

class _NoDataInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.lightbulb_outline,
            color: Colors.orange,
          ),
          Text('暂无相关数据,您可以更换条件试试')
        ],
      ),
    );
  }
}
