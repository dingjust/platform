import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'cooperator_item.dart';

///外接订单View
class CooperatorsView extends StatelessWidget {
  final EnumModel status;

  const CooperatorsView({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CooperatorV2State>(
      builder: (context, CooperatorV2State state, _) => Container(
        child: state.getEntry(status.code).totalElements > -1
            ? CooperatorsList(status, state)
            : Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

///外接订单列表
class CooperatorsList extends StatelessWidget {
  final CooperatorV2State state;

  final EnumModel status;

  ScrollController _scrollController;

  CooperatorsList(this.status,
      this.state, {
        Key key,
      }) : super(key: key) {
    this._scrollController = ScrollController();
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMore(status: status.code);
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
              state.cooperators(status.code).isNotEmpty
                  ? Column(
                children: state
                    .cooperators(status.code)
                    .map((model) => Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 5, horizontal: 10),
                  child: CooperatorItem(
                    isSelected: state?.selectedData
                        ?.any((e) => e.id == model.id),
                    onItemTap: state?.onItemTap,
                    onItemLongPress: () => onItemLongPress(model),
                    model: model,
                  ),
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

  ///长按删除
  void onItemLongPress(CooperatorModel model) {
    BotToast.showCustomText(
        onlyOne: true,
        duration: null,
        clickClose: false,
        crossPage: false,
        backgroundColor: Colors.black38,
        toastBuilder: (cancelFunc) =>
            AlertDialog(
              content: Container(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text('是否确认删除合作商？'),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: FlatButton(
                                onPressed: cancelFunc, child: Text('否'))),
                        Expanded(
                            child: FlatButton(
                                onPressed: () => _onDelete(model),
                                child: Text('是',
                                    style: TextStyle(
                                      color: Colors.blue,
                                    ))))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  void _onDelete(CooperatorModel model) async {
    Function cancelFunc =
    BotToast.showLoading(crossPage: false, clickClose: false);
    String response = await CooperatorRepositoryImpl.delete(model.id);
    cancelFunc.call();
    if (response != null) {
      BotToast.showText(text: '删除成功');
      state.clear();
    } else {
      BotToast.showText(text: '操作失败');
    }
  }
}
