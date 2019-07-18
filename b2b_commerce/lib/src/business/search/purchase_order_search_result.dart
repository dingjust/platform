import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PurchaseOrderSearchResultPage extends StatelessWidget {
  PurchaseOrderSearchResultPage(
      {Key key, this.searchModel, this.isContractSelect: false})
      : super(key: key);
  bool isContractSelect;
  SearchModel searchModel;
  GlobalKey _productionOrderBlocProviderKey = GlobalKey();
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
      key: _productionOrderBlocProviderKey,
      bloc: PurchaseOrderBLoC.instance,
      child: WillPopScope(
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
                        border: Border.all(color: Colors.grey[300], width: 0.5),
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
          body: ProductionListView(
            keyword: searchModel.keyword,
            isContractSelect: isContractSelect,
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          PurchaseOrderBLoC().refreshData('ALL');
        },
      ),
    );
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
                searchModelType: SearchModelType.PURCHASE_ORDER,
                route: GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
          ),
        ),
      );
    });
  }
}

class ProductionListView extends StatelessWidget {
  String keyword;
  bool isContractSelect;

  ScrollController _scrollController = new ScrollController();

  ProductionListView({Key key, @required this.keyword, this.isContractSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('=======');

    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);
    bloc.reset();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByKeyword(keyword);
      }
    });

    return Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey[200],
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<PurchaseOrderModel>>(
                initialData: null,
                stream: bloc.purchaseStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByKeyword(keyword);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.data.length <= 0) {
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
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyHelpPage()));
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
                      children: snapshot.data.map((order) {
                        return PurchaseOrderItem(
                          order: order,
                          isContractSelect: isContractSelect,
                        );
                      }).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }),
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
                        opacity: snapshot.data ? 1.0 : 0);
              },
            ),
          ],
        ));
  }
}
