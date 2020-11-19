import 'package:b2b_commerce/src/business/orders/sales_production/progress_work_sheet/progress_work_sheet_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 生产进度view
class ProgressWorkSheetView extends StatelessWidget {
  final EnumModel status;

  const ProgressWorkSheetView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressWorkSheetState>(
      builder: (context, ProgressWorkSheetState state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? ProgressWorkSheetList(status: status, state: state)
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ProgressWorkSheetList extends StatelessWidget {
  final ProgressWorkSheetState state;

  final EnumModel status;

  ScrollController _scrollController;

  ProgressWorkSheetList({Key key, this.state, this.status}) : super(key: key) {
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
                        .map((model) => ProgressWorkSheetItem(model: model))
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
