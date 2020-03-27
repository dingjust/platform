import 'dart:convert';

import 'package:b2b_commerce/src/business/orders/sale/sale_order_list_item.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SalesOrderSearchResultPage extends StatelessWidget {
  SalesOrderSearchResultPage({Key key, this.searchModel}) : super(key: key);

  SearchModel searchModel;
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SaleOrdersState>(
        builder: (context) => SaleOrdersState(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        onClick(context);
                      },
                      child: Container(
                        height: 35,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.grey[300], width: 0.5),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '${searchModel.keyword}',
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
            body: Consumer<SaleOrdersState>(
              builder: (context, SaleOrdersState state, _) =>
                  Container(
                    child: state
                        .getEntry('SEARCH', keyword: searchModel.keyword)
                        .totalElements >
                        -1
                        ? SaleOrderSearchList(
                      state: state,
                      keyword: searchModel.keyword,
                    )
                        : Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
            )));
  }

  void onClick(BuildContext context) {
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
                keyword: searchModel.keyword,
                searchModelType: SearchModelType.SALE_ORDER,
                route: GlobalConfigs.SALE_HISTORY_KEYWORD_KEY),
          ),
        ),
      );
    });
  }
}

class SaleOrderSearchList extends StatelessWidget {
  final String status = 'SEARCH';

  final String keyword;

  final SaleOrdersState state;

  final ScrollController _scrollController = ScrollController();

  SaleOrderSearchList({
    Key key,
    this.keyword,
    this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMoreOrders(status, keyword: keyword);
      }
    });

    return Container(
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              state
                  .orders(status, keyword: keyword)
                  .isNotEmpty
                  ? Column(
                children: state
                    .orders(status, keyword: keyword)
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
        .getEntry(status, keyword: keyword)
        .currentPage + 1 ==
        state
            .getEntry(status, keyword: keyword)
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
