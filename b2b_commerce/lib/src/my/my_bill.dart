import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
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
          title: Text(
            '账单',
            style: TextStyle(color: Colors.black),
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

class BillListView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  ///当前选中条件
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyBillBLoC>(context);

    // 监听筛选条件更改
    bloc.conditionStream.listen((date) {
      selectDate = date;
      //清空数据
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByDate(date: selectDate);
      }
    });

    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        color: Color.fromRGBO(245, 245, 245, 1),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.refreshData(date: selectDate);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              IncomeComparison(
                height: 120,
                income: 8000.00,
                expenditure: 20134.00,
                lineHeight: 8,
              ),
              StreamBuilder<List<BillModel>>(
                stream: bloc.stream,
                initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List<BillModel>> snapshot) {
                  if (snapshot.data == null) {
                    //默认条件查询
                    bloc.filterByDate(date: selectDate);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: ProgressIndicatorFactory.buildDefaultProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((item) {
                        return BillCard(
                          model: item,
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
                  if (snapshot.data) {
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "(￢_￢)已经到底了",
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
                  return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(opacity: snapshot.data ? 1.0 : 0);
                },
              ),
            ],
          ),
        ));
  }
}

class BillCard extends StatelessWidget {
  BillCard({Key key, this.height = 150, this.model}) : super(key: key);

  final double height;
  final BillModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Text(
            model.date.day == DateTime.now().day ? '今日' : '${model.date.month}-${model.date.day}',
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1), fontSize: 15),
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '${BillTypeLocalizedMap[model.type]}',
                      style: TextStyle(fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '- ￥ ${model.amount}',
                      style: TextStyle(fontSize: 20, color: Color.fromRGBO(255, 68, 68, 1)),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      model.order != null ? '生产订单${model.order.code}' : '提现到银行卡${model.bankAccount}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(
                      '余额￥${model.balance}',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
