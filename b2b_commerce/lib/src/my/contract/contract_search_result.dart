import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/proofing/proofing_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/contract/contract_item_page.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractSearchResultPage extends StatefulWidget {
  ContractSearchResultPage({
    Key key,
    @required this.searchModel,
  }) : super(key: key);

  SearchModel searchModel;

  _ContractSearchResultPageState createState() =>
      _ContractSearchResultPageState();
}

class _ContractSearchResultPageState extends State<ContractSearchResultPage> {
  final GlobalKey _globalKey = GlobalKey<_ContractSearchResultPageState>();
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<MyContractBLoC>(
      key: _globalKey,
      bloc: MyContractBLoC.instance,
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
          body: ContractListView(
            keyword: widget.searchModel.keyword,
          ),
        ),
        onWillPop: () {
          Navigator.of(context).pop();
          MyContractBLoC().refreshData('ALL');
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
            LocalStorage.get(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY),
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
                route: GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY),
          ),
        ),
      );
    });
  }
}

class ContractListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ContractListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyContractBLoC>(context);
    bloc.refreshData('ALL');
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
            StreamBuilder<List<ContractModel>>(
                initialData: null,
//                stream: bloc.proofingStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ContractModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getDataByKeyword(keyword);
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
                                  : '没有相关合同数据',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((model) {
                        return ContractItemPage(
                          model: model,
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
