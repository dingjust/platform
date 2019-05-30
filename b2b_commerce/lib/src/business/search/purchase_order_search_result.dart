import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PurchaseOrderSearchResultPage extends StatefulWidget {
  PurchaseOrderSearchResultPage({Key key, this.keyword}) : super(key: key);

  _PurchaseOrderSearchResultPageState createState() => _PurchaseOrderSearchResultPageState();

  String keyword;
}

class _PurchaseOrderSearchResultPageState extends State<PurchaseOrderSearchResultPage> {
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
                              '${widget.keyword}',
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
                keyword: widget.keyword,
              ),
            ),
          onWillPop: (){
            Navigator.of(context).pop();
            PurchaseOrderBLoC().refreshData('ALL');
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchModelPage(historyKeywords: historyKeywords,keyword: widget.keyword,),
        ),
      );
    });
  }
}

class ProductionListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ProductionListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);
    bloc.reset();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByKeyword(keyword);
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
                        return PurchaseOrderItem(
                          order: order,
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
