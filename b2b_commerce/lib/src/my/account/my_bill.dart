import 'dart:async';

import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/my/account/bill_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:connectivity/connectivity.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyBillPage extends StatefulWidget {
  final Widget child;

  MyBillPage({Key key, this.child}) : super(key: key);

  _MyBillPageState createState() => _MyBillPageState();
}

class _MyBillPageState extends State<MyBillPage> {
  GlobalKey _myBillBLoCProviderKey = GlobalKey();
  StreamController streamController;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();

    return BLoCProvider<MyBillBLoC>(
      key: _myBillBLoCProviderKey,
      bloc: MyBillBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: const Text(
            '账单',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Container(),
            bottom: DateBar(
              streamController: MyBillBLoC.instance.conditionController,
              initeDate: date,
            ),
          ),
          body: BillListView(),
        ),
      ),
    );
  }
}

class BillListView extends StatefulWidget {

  _BillListViewState createState() => _BillListViewState();

}
class _BillListViewState extends State<BillListView>{
  final ScrollController _scrollController = ScrollController();

  ///当前选中条件
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var bloc = BLoCProvider.of<MyBillBLoC>(context);

    // 监听筛选条件更改
    bloc.conditionStream.listen((date) {
      selectedDate = date;
      bloc.filterByDate(date: selectedDate);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByDate(date: selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyBillBLoC>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: const Color.fromRGBO(245, 245, 245, 1),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.refreshData(date: selectedDate);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            // IncomeComparison(
            //   height: 120,
            //   income: 8000.00,
            //   expenditure: 20134.00,
            //   lineHeight: 8,
            // ),
            StreamBuilder<List<BillModel>>(
              stream: bloc.stream,
              initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<List<BillModel>> snapshot) {
                if (snapshot.data == null) {
                  //默认条件查询
                  bloc.filterByDate(date: selectedDate);
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
                                : '没有相关消息数据',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map(
                      (item) {
                        return BillCard(model: item);
                      },
                    ).toList(),
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
                // if (snapshot.data) {
                //   _scrollController.animateTo(
                //     _scrollController.offset - 70,
                //     duration: new Duration(milliseconds: 500),
                //     curve: Curves.easeOut,
                //   );
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
                  opacity: snapshot.data ? 1.0 : 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BillCard extends StatelessWidget {
  BillCard({Key key, this.height = 120, this.model}) : super(key: key);

  final double height;
  final BillModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            model.creationtime.day == DateTime
                .now()
                .day
                ? '今日'
                : '${model.creationtime.month}-${model.creationtime.day}',
            style: const TextStyle(
                color: const Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
          ),
          GestureDetector(
            onTap: () => _onTap(context),
            child: Container(
              height: height,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '${FlowSourceLocalizedMap[model.flowSource]}',
                        style: const TextStyle(
                            fontSize: 18,
                            color: const Color.fromRGBO(100, 100, 100, 1)),
                      ),
                      Text(
                        '${AmountStatusLocalizedMap[model.amountStatus]}',
                        style: const TextStyle(
                            fontSize: 18,
                            color: const Color.fromRGBO(100, 100, 100, 1)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                          '${getSymbol(model.amountFlowType)} ￥ ${model
                              .amount}',
                          style: TextStyle(
                            fontSize: 20,
                            color: getSymbolColor(model.amountFlowType),
                          ))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        model.flowSource != FlowSource.CASH_OUT
                            ? '${model.orderCode}'
                            : '提现到银行卡${model.account.cardNumber}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      )
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Text(
                  //       'wan',
                  //       style:
                  //           const TextStyle(fontSize: 18, color: Colors.black),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///详情页跳转
  void _onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BillDetailPage(
          id: model.id,
            )));
  }

  String getSymbol(AmountFlowType type) {
    print(type);
    String text = '';

    if(type == AmountFlowType.INFLOW){
      text = '+';
    }else if(type == AmountFlowType.OUTFLOW){
      text = '-';
    }
    return text;
  }

  Color getSymbolColor(AmountFlowType type) {
    return type == AmountFlowType.INFLOW
        ? Color.fromRGBO(255, 68, 68, 1)
        : Colors.black54;
  }

  String getFlowSourceOrder(FlowSource flowSource){
    String text = '';
    if(flowSource == FlowSource.PROOFING){
      text = '打样订单';
    }else if(flowSource == FlowSource.PURCHASE_DEPOSIT){
      text = '生产订单';
    }else if(flowSource == FlowSource.PURCHASE_BALANCE){
      text = '生产订单';
    }
    return text;
  }
}
