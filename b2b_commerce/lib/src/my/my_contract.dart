import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/_shared/widgets/tab_factory.dart';
import 'package:b2b_commerce/src/business/search/history_search.dart';
import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/my/contract/contract_select_from_page.dart';
import 'package:b2b_commerce/src/my/contract/join_supplier_contract_page.dart';
import 'package:connectivity/connectivity.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'contract/contract_item_page.dart';
import 'contract/contract_template.dart';
import 'contract/float_select_page.dart';
import 'contract/join_order_contract_page.dart';
import 'seal/contract_seal_page.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('WAIT_ME_SIGN', '待我签署'),
  EnumModel('WAIT_PARTNER_SIGN', '待他签署'),
  EnumModel('COMPLETE', '已签署'),
  EnumModel('INVALID', '已作废'),
];

class MyContractPage extends StatefulWidget {
  String keyword;
  String type;

  MyContractPage({this.keyword, this.type});

  _MyContractPageState createState() => _MyContractPageState();
}

class _MyContractPageState extends State<MyContractPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey _globalKey = GlobalKey<_MyContractPageState>();
  List<String> historyKeywords;
  var controller;

  @override
  void initState() {
    controller = TabController(
      initialIndex: widget.type == 'WAIT_ME_SIGN'
          ? 1
          : widget.type == 'WAIT_PARTNER_SIGN'
          ? 2
          : 0,
      length: statuses.length,
      vsync: this, //动画效果的异步处理，默认格式
    );

    super.initState();
  }

  @override
  void dispose() {
    MyContractBLoC.instance.clear();
    super.dispose();
  }

  Widget _buildSearchButton() {
    return IconButton(
        icon: const Icon(B2BIcons.search, size: 20),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HistorySearch(
                        hintText: '请输入编号，名称，订单号，合作商名称搜索',
                        historyKey: GlobalConfigs.CONTRACT_HISTORY_KEYWORD_KEY,
                      )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<MyContractBLoC>(
      key: _globalKey,
      bloc: MyContractBLoC.instance,
      child: Scaffold(
          appBar: AppBar(
              brightness: Brightness.light,
              centerTitle: true,
              elevation: 0,
              title: Text('合同管理',
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              actions: <Widget>[_buildSearchButton()],
              bottom: _buildBarBottom()),
          body: DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
              body: TabBarView(
                controller: controller,
                children: statuses
                    .map((status) =>
                    MyContractListPage(
                      status: status,
                      keyword: widget.keyword,
                    ))
                    .toList(),
              ),
            ),
          ),
          bottomNavigationBar: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ContractSelectFromItemPage()));
            },
            child: Container(
                color: Color(0xffF7F7F7),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                height: 72,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[Color(0xffFED800), Color(0xFFFEC300)],

                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(137, 124, 21, 0.16),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, 3.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(24)),
                    child: Center(
                      child: Text(
                        '创建新合同',
                        style: TextStyle(
                          color: Color(0xff222222),
                          fontSize: 15,
                        ),
                      ),
                    ))),
          )),
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
            action1: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JoinOrderContractPage()));
            },
            action2: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JoinSupplierContractPage()));
            },
          );
        });
  }

  PreferredSize _buildBarBottom({double height = 80,
    TextStyle style =
    const TextStyle(color: Color(0xff666666), fontSize: 12)}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: Container(
        height: height,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyContractTemplatePage()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    B2BV2Image.template(width: 36, height: 36),
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '我的模板',
                        style: style,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ContractSealPage(
                              isSelect: false,
                            )));
              },
              child: Container(
                margin: EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    B2BV2Image.seal(width: 36, height: 36),
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '我的印章',
                        style: style,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class MyContractListPage extends StatefulWidget {
  final String keyword;
  final EnumModel status;

  final ScrollController scrollController = ScrollController();

  MyContractListPage({this.keyword: '', this.status = const EnumModel('ALL', '全部')});

  _MyContractListPageState createState() => _MyContractListPageState();
}

class _MyContractListPageState extends State<MyContractListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    var bloc = BLoCProvider.of<MyContractBLoC>(context);
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(status: widget.status.code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyContractBLoC>(context);
    return Container(
      decoration: BoxDecoration(color: Color(0xffF7F7F7)),
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.refreshData(widget.status.code, widget.keyword);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<ContractData>(
              stream: widget.status == null
                  ? bloc.stream
                  : bloc.stream
                  .where((data) => data.status == widget.status.code),
              // initialData: null,
              builder:
                  (BuildContext context, AsyncSnapshot<ContractData> snapshot) {
                if (snapshot.data == null) {
                  bloc.getData(status: widget.status.code);
                  return ProgressIndicatorFactory
                      .buildPaddedProgressIndicator();
                }
                // if (snapshot.hasData) {
                if (snapshot.data.data.isNotEmpty) {
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
                // } else {
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
                              : '没有相关数据',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                  ],
                );
                // }
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.bottomStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ScrolledToEndTips(
                  hasContent: snapshot.data,
                  scrollController: widget.scrollController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return Opacity(
                  opacity: snapshot.data ? 1 : 0,
                  child: Container(
                    height: 80,
                    child: Center(
                      child: const CircularProgressIndicator(),
                    ),
                  ),
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
