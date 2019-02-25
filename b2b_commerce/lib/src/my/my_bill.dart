import 'dart:async';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class MyBillPage extends StatefulWidget {
  final Widget child;

  MyBillPage({Key key, this.child}) : super(key: key);

  _MyBillPageState createState() => _MyBillPageState();
}

class _MyBillPageState extends State<MyBillPage> {
  StreamController streamController;

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();

    return Scaffold(
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
            streamController: streamController,
            initeDate: date,
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          color: Color.fromRGBO(245, 245, 245, 1),
          child: ListView(
            children: <Widget>[
              IncomeComparison(
                height: 120,
                income: 8000.00,
                expenditure: 20134.00,
                lineHeight: 8,
              ),
              BillCard(),
              BillCard(),
              BillCard(),
              BillCard(),
              BillCard(),
              BillCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class BillCard extends StatelessWidget {
  BillCard({Key key, this.height = 150}) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '提现',
            style: TextStyle(
                fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1)),
          ),
          Text(
            '- ￥ 11,919.86',
            style:
                TextStyle(fontSize: 20, color: Color.fromRGBO(255, 68, 68, 1)),
          ),
          Text(
            '生产订单NA1231309091090',
            style: TextStyle(
                fontSize: 18, color: Colors.black),
          ),
          Text(
            '余额￥9000.00',
            style: TextStyle(
                fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
