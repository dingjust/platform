import 'package:b2b_commerce/src/business/orders/quote_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
          floatingActionButton: _ToTopBtn()),
    );
  }
}

class QuotesListView extends StatelessWidget {
  final RequirementOrderModel order;

  /// 顶级页面context
  final BuildContext pageContext;

  ScrollController _scrollController = new ScrollController();

  QuotesListView({Key key, @required this.order, @required this.pageContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<RequirementQuoteDetailBLoC>(context);

    void _handleRefresh() {
      bloc.refreshData(order.code);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(order.code);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey[100],
      child: RefreshIndicator(
        onRefresh: () async {
          bloc.refreshData(order.code);
        },
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<QuoteModel>>(
                stream: bloc.stream,
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuoteModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData(order.code);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data
                          .map((quote) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: QuoteItem(
                                  model: quote,
                                  onRefresh: _handleRefresh,
                                  pageContext: pageContext,
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
                  if (snapshot.data) {
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "┑(￣Д ￣)┍ 已经到底了",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: snapshot.data ? 1.0 : 0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ]),
      ),
    );
  }
}

class _ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<RequirementQuoteDetailBLoC>(context);

    return StreamBuilder<bool>(
        stream: bloc.toTopBtnStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data
              ? FloatingActionButton(
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.returnToTop();
                  },
                  backgroundColor: Colors.blue,
                )
              : Container();
        });
  }
}
