import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///用户积分记录
class IntegralExchangeHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserIntegralExchangeHistoryState>(
      builder: (context, UserIntegralExchangeHistoryState state, _) =>
          Container(
        child: state.integralHistories != null
            ? IntegralExchangeHistoryListView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class IntegralExchangeHistoryListView extends StatelessWidget {
  final UserIntegralExchangeHistoryState state;

  final ScrollController _scrollController = ScrollController();

  IntegralExchangeHistoryListView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMore();
      }
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            state.integralHistories.isNotEmpty
                ? Column(
                    children: state.integralHistories
                        .map(
                          (model) => IntegralExchangeHistoryItem(
                            model: model,
                          ),
                        )
                        .toList(),
                  )
                : _NoDataInfoRow(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: state.loadingMore ? 1.0 : 0,
            ),
            _buildEnd()
          ]),
    );
  }

  Widget _buildEnd() {
    return state.isDownEnd
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

class IntegralExchangeHistoryItem extends StatelessWidget {
  final IntegralExchangeHistoryModel model;

  const IntegralExchangeHistoryItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '积分兑换红包',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Color(0xff303444)),
                  )),
                  Text('${PointsExchangeStateLocalizedMap[model.state]}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PointsExchangeStateColorMap[model.state]))
                ],
              ),
              // Container(
              //   height: 10,
              // ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    '编号：${model.code}',
                    style: TextStyle(color: Colors.grey),
                  )),
                  Container(
                    width: 60,
                    child: Text(
                      '￥ ${model.exchangeAmount}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '兑换：${model.points}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Icon(
                      B2BIcons.integral,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ),
                  // Expanded(
                  //     child: Text(
                  //   '${DateFormatUtil.formatYMDHMS(model.updateTime)}',
                  //   style: TextStyle(color: Colors.grey),
                  // )),
                ],
              )
            ],
          )),
          // Container(
          //   width: 60,
          //   child: Text(
          //     '${symbol()}${model.points}',
          //     textAlign: TextAlign.right,
          //     style: TextStyle(
          //         color: Color(0xFFff952f),
          //         fontSize: 25,
          //         fontWeight: FontWeight.bold),
          //   ),
          // )
        ],
      ),
    );
  }

  ///活动
  String getEventStr(ActivityEvent event) {
    if (event == ActivityEvent.TYPE_REC_REGISTER) {
      return '邀新用户注册奖励积分';
    } else {
      return '其他';
    }
  }

  String symbol() {
    return model.points > 0 ? '+' : '-';
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
          Text('暂无相关记录')
        ],
      ),
    );
  }
}
