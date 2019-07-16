import 'dart:convert';

import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'contract/contract_item_page.dart';
import 'contract/float_select_page.dart';
import 'contract/join_order_contract_page.dart';
import 'my_help.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('1', '待签署'),
  EnumModel('2', '已签署'),
  EnumModel('3', '已失效'),
];

class MyContractPage extends StatefulWidget {
  _MyContractPageState createState() => _MyContractPageState();
}

class _MyContractPageState extends State<MyContractPage> with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{

  final GlobalKey _globalKey = GlobalKey<_MyContractPageState>();
  List<String> historyKeywords;
  var controller;

  @override
  void initState() {
    controller = TabController(
      length: statuses.length,
      vsync: this, //动画效果的异步处理，默认格式
    );
    super.initState();
  }

  Widget _buildSearchButton() {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: (){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack: LocalStorage.get(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
                outsideDismiss: false,
                loadingText: '加载中。。。',
                entrance: '',
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
              builder: (context) =>
                  SearchModelPage(
                    searchModel:SearchModel(
                      historyKeywords: historyKeywords,
                      searchModelType: SearchModelType.PURCHASE_ORDER,
                      route: GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY,
                    ),
                  ),
            ),
          );
        });
      },
//      onPressed: () => showSearch(context: context, delegate: PurchaseOrderSearchDelegate()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return BLoCProvider<MyContractBLoC>(
      key: _globalKey,
      bloc: MyContractBLoC.instance,
      child: Scaffold(
          appBar: AppBarFactory.buildDefaultAppBar(
            '合同管理',
            actions: <Widget>[_buildSearchButton()],
          ),
          body: Scaffold(
              appBar: TabBar(
                controller: controller,
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                tabs: statuses.map((tab) {
                  return Tab(text: tab.name);
                }).toList(),),
              body: TabBarView(
                controller: controller,
                children: statuses.map((status) => MyContractListPage(status: status)).toList(),
              ),
          ),
          bottomNavigationBar: Container(
            color: Colors.white10,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '签署新合同',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () {
                openSelectButton(context);
              },
            ),
          )
      ),
    );
  }

  openSelectButton(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return FloatSelectPage(
            buttonText1: '关联订单合同',
            buttonText2: '非关联订单合同',
            action1: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) =>JoinOrderContractPage()));
            },
          );
        }
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class MyContractListPage extends StatefulWidget{
  final String keyword;
  final EnumModel status;

  final ScrollController scrollController = ScrollController();

  MyContractListPage({this.keyword,this.status});

  _MyContractListPageState createState() => _MyContractListPageState();
}

class _MyContractListPageState extends State<MyContractListPage> with AutomaticKeepAliveClientMixin{

  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<MyContractBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.status.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyContractBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: RefreshIndicator(
        onRefresh: () async {
            return await bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<ContractData>(
              stream: widget.status == null
                  ? bloc.stream
                  : bloc.stream.where((purchaseData) =>
              purchaseData.status == widget.status.code),
              // initialData: null,
              builder:
                  (BuildContext context, AsyncSnapshot<ContractData> snapshot) {
                if (snapshot.data == null) {
                    bloc.getData(widget.status.code);

                  return ProgressIndicatorFactory
                      .buildPaddedProgressIndicator();
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
                    children: snapshot.data.data.map((model) {
                      return ContractItemPage(
                        model: model,
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;


}


