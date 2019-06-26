import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/requirement_orders.dart';
import 'package:b2b_commerce/src/my/account/amount_flow_detail.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/scroll_to_top_button.dart';

class AmountFlowsPage extends StatefulWidget {
  const AmountFlowsPage({Key key}) : super(key: key);

  _AmountFlowsPageState createState() => _AmountFlowsPageState();
}

class _AmountFlowsPageState extends State<AmountFlowsPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey _requirementQuoteDetailBLoCKey = GlobalKey();

    return BLoCProvider<AmountFlowBLoC>(
      key: _requirementQuoteDetailBLoCKey,
      bloc: AmountFlowBLoC.instance,
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '交易明细',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: AmountFlowListView(),
          floatingActionButton: ScrollToTopButton<AmountFlowBLoC>()),
    );
  }
}

class AmountFlowListView extends StatefulWidget {
  ScrollController _scrollController = new ScrollController();

  AmountFlowListView({Key key}) : super(key: key);

  AmountFlowListViewState createState() => AmountFlowListViewState();
}

class AmountFlowListViewState extends State<AmountFlowListView> {
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<AmountFlowBLoC>(context);

    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels ==
          widget._scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore();
      }
    });

    //监听滚动事件，打印滚动位置
    widget._scrollController.addListener(() {
      if (widget._scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (widget._scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        widget._scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
      color: Colors.grey[100],
      child: RefreshIndicator(
        onRefresh: () async {
          bloc.refreshData();
        },
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget._scrollController,
            children: <Widget>[
              StreamBuilder<List<AmountFlowModel>>(
                stream: bloc.stream,
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<AmountFlowModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData();
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data
                          .map((model) => AmountFlowItem(
                                model: model,
                              ))
                          .toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.bottomStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  // if (snapshot.data) {
                  //   _scrollController.animateTo(_scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: widget._scrollController,
                  );
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ]),
      ),
    );
  }
}

class AmountFlowItem extends StatelessWidget {
  final AmountFlowModel model;

  const AmountFlowItem({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AmountFlowDetailPage()));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${FlowSourceLocalizedMap[model.flowSource]}',
                    style: TextStyle(fontSize: 18),
                  ),
                  RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        text:
                            model.flowSource == FlowSource.CASH_OUT ? '+' : '-',
                        children: <TextSpan>[
                          TextSpan(text: '￥${model.amount}')
                        ]),
                  )
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '${DateFormatUtil.format(model.creationtime)}',
                  style: TextStyle(color: Colors.grey[500]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
