import 'dart:async';

import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/my/account/bill_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class TransactionPage extends StatefulWidget {
  final Widget child;

  TransactionPage({Key key, this.child}) : super(key: key);

  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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

class BillListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  ///当前选中条件
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<MyBillBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByDate(date: selectedDate);
      }
    });

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
            IncomeComparison(
              height: 120,
              income: 8000.00,
              expenditure: 20134.00,
              lineHeight: 8,
            ),
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
            model.date.day == DateTime.now().day
                ? '今日'
                : '${model.date.month}-${model.date.day}',
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
                        '${BillTypeLocalizedMap[model.type]}',
                        style: const TextStyle(
                            fontSize: 18,
                            color: const Color.fromRGBO(100, 100, 100, 1)),
                      ),
                      Text(
                        '成功',
                        style: const TextStyle(
                            fontSize: 18,
                            color: const Color.fromRGBO(100, 100, 100, 1)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '- ￥ ${model.amount}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: const Color.fromRGBO(255, 68, 68, 1)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        model.order != null
                            ? '生产订单${model.order.code}'
                            : '提现到银行卡${model.bankAccount}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '余额￥${model.balance}',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      )
                    ],
                  ),
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
              code: model.code,
            )));
  }
}
