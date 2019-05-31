import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/proofing/proofing_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProofingSearchResultPage extends StatefulWidget{
  ProofingSearchResultPage({
    Key key,
    @required this.searchModel,
  }) : super(key: key);

  SearchModel searchModel;

  _ProofingSearchResultPageState createState() => _ProofingSearchResultPageState();
}

class _ProofingSearchResultPageState extends State<ProofingSearchResultPage>{
  final GlobalKey _globalKey = GlobalKey<_ProofingSearchResultPageState>();
  List<String> historyKeywords;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
      key: _globalKey,
      bloc: ProofingOrdersBLoC.instance,
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: (){
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
          body: ProofingOrderListView(
            keyword: widget.searchModel.keyword,
          ),
        ),
        onWillPop: (){
          Navigator.of(context).pop();
          ProofingOrdersBLoC().refreshData('ALL');
        },
      ),
    );
  }

  void onClick(){
    Navigator.pop(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: LocalStorage.get(GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY),
            outsideDismiss: false,
            loadingText: '加载中。。。',
            entrance: 'createPurchaseOrder',
          );
        }
    ).then((value){
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
              route: GlobalConfigs.PRODUCTION_HISTORY_KEYWORD_KEY
            ),
          ),
        ),
      );
    });
  }

}


class ProofingOrderListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ProofingOrderListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);
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
            StreamBuilder<List<ProofingModel>>(
                initialData: null,
                stream: bloc.proofingStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProofingModel>> snapshot) {
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
                              '没有相关订单数据',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                        Container(
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
                      ],
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((order) {
                        return ProofingOrderItem(
                          model: order,
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