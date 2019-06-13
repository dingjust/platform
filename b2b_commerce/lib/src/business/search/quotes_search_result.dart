import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QuoteSearchResultPage extends StatefulWidget {
  QuoteSearchResultPage({
    Key key,
    @required this.searchModel,
  }) : super(key: key);

  SearchModel searchModel;

  _QuoteSearchResultPageState createState() => _QuoteSearchResultPageState();
}

class _QuoteSearchResultPageState extends State<QuoteSearchResultPage> {
  final GlobalKey _globalKey = GlobalKey<_QuoteSearchResultPageState>();
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onClick();
                    },
                    child: Container(
                      height: 35,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          '${widget.searchModel.keyword}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: QuoteOrderListView(
            keyword: widget.searchModel.keyword,
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          QuoteOrdersBLoC().refreshData('ALL');
        },
      ),
    );
  }

  void onClick() {
    Navigator.pop(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            LocalStorage.get(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
            outsideDismiss: false,
            loadingText: '加载中。。。',
            entrance: '',
          );
        }).then((value) {
      if (value != null && value != '') {
        List<dynamic> list = json.decode(value);
        historyKeywords = list.map((item) => item as String).toList();
      } else {
        historyKeywords = [];
      }
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchModelPage(
            searchModel: SearchModel(
              historyKeywords: historyKeywords,
              keyword: widget.searchModel.keyword,
              searchModelType: SearchModelType.QUOTE_ORDER,
              route: GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
            ),
          ),
        ),
      );
    });
  }
}

class QuoteOrderListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  QuoteOrderListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: <Widget>[
          StreamBuilder<QuoteData>(
            stream: bloc.stream,
            builder: (BuildContext context, AsyncSnapshot<QuoteData> snapshot) {
              if (snapshot.data == null) {
                bloc.filterByKeyword(keyword);
                return ProgressIndicatorFactory.buildPaddedProgressIndicator();
              }
              if (snapshot.data.data.length <= 0) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Image.asset(
                        'temp/logo2.png',
                        package: 'assets',
                        width: 80,
                        height: 80,
                      ),
                    ),
                    Container(
                        child: Text(
                          AppBLoC.instance.getConnectivityResult ==
                              ConnectivityResult.none
                              ? '网络链接不可用请重试'
                              : '没有相关订单数据',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                    AppBLoC.instance.getConnectivityResult !=
                        ConnectivityResult.none
                        ? Container(
                      child: FlatButton(
                        color: Color.fromRGBO(255, 214, 12, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MyHelpPage()));
                        },
                        child: Text('如何创建订单？'),
                      ),
                    )
                        : Container()
                  ],
                );
              }
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.data.map((order) {
                    return QuoteListItem(
                      model: order,
                    );
                  }).toList(),
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
              return ScrolledToEndTips(
                hasContent: snapshot.data,
                scrollController: _scrollController,
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
        ],
      ),
    );
  }
}
