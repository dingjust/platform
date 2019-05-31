import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../_shared/widgets/scroll_to_top_button.dart';
import './quote_item.dart';

class RequirementQuoteDetailPage extends StatefulWidget {
  final RequirementOrderModel order;

  const RequirementQuoteDetailPage({Key key, @required this.order})
      : super(key: key);

  _RequirementQuoteDetailPageState createState() =>
      _RequirementQuoteDetailPageState();
}

class _RequirementQuoteDetailPageState
    extends State<RequirementQuoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey _requirementQuoteDetailBLoCKey = GlobalKey();

    return BLoCProvider<RequirementQuoteDetailBLoC>(
      key: _requirementQuoteDetailBLoCKey,
      bloc: RequirementQuoteDetailBLoC.instance,
      child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '报价详情',
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: QuotesListView(
            order: widget.order,
            pageContext: context,
          ),
          floatingActionButton:
              ScrollToTopButton<RequirementQuoteDetailBLoC>()),
    );
  }
}

class QuotesListView extends StatefulWidget {
  final RequirementOrderModel order;

  /// 顶级页面context
  final BuildContext pageContext;

  ScrollController _scrollController = new ScrollController();

  QuotesListView({Key key, @required this.order, @required this.pageContext})
      : super(key: key);

  QuotesListViewState createState() =>
      QuotesListViewState();
}

class QuotesListViewState extends State<QuotesListView>{

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<RequirementQuoteDetailBLoC>(context);

    void _handleRefresh() {
      bloc.refreshData(widget.order.code);
    }

    widget._scrollController.addListener(() {
      if (widget._scrollController.position.pixels ==
          widget._scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(widget.order.code);
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
      padding: EdgeInsets.all(10),
      color: Colors.grey[100],
      child: RefreshIndicator(
        onRefresh: () async {
          bloc.refreshData(widget.order.code);
        },
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: widget._scrollController,
            children: <Widget>[
              StreamBuilder<List<QuoteModel>>(
                stream: bloc.stream,
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuoteModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData(widget.order.code);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data
                          .map((quote) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: QuoteItem(
                                  model: quote,
                                  onRefresh: _handleRefresh,
                                  pageContext: widget.pageContext,
                                ),
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
