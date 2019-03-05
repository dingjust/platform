import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementQuoteDetailPage extends StatefulWidget {
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
        body: QuotesListView(),
        floatingActionButton: _ToTopBtn(),
      ),
    );
  }
}

class QuotesListView extends StatelessWidget {
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<RequirementQuoteDetailBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore();
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
          return await bloc.refreshData();
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
                    bloc.getData();
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

class QuoteItem extends StatelessWidget {
  const QuoteItem({Key key, this.model}) : super(key: key);

  final QuoteModel model;

  static Map<QuoteState, MaterialColor> _statusColors = {
    QuoteState.SELLER_SUBMITTED: Colors.green,
    QuoteState.BUYER_APPROVED: Colors.blue,
    QuoteState.BUYER_REJECTED: Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS_DETAIL);
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => QuoteOrderDetailPage(
        //           item: model,
        //         )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildMain(),
            model.state == QuoteState.SELLER_SUBMITTED
                ? _buildSummary()
                : Container(),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildMain() {
    return Container(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Stars(
                            starLevel: model.belongTo.starLevel,
                            color: Color.fromRGBO(255, 183, 0, 1),
                            highlightOnly: false,
                          ),
                          RichText(
                            text: TextSpan(
                                text: '历史接单',
                                style: TextStyle(color: Colors.black54),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '214',
                                      style: TextStyle(color: Colors.red)),
                                  TextSpan(
                                      text: '单',
                                      style: TextStyle(color: Colors.black54)),
                                ]),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '报价：',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '￥',
                          style: TextStyle(fontSize: 14, color: Colors.red)),
                      TextSpan(
                          text: '${model.totalPrice}',
                          style: TextStyle(color: Colors.red)),
                    ]),
              ),
              Text(QuoteStateLocalizedMap[model.state],
                  style: TextStyle(
                      color: _statusColors[model.state], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${model.belongTo.name}',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '报价时间：${DateFormatUtil.format(model.creationTime)}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.red,
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '拒绝报价',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 149, 22, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '确认报价',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
        ],
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
