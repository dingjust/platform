import 'dart:async';

import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/my/account/my_bill.dart';
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
