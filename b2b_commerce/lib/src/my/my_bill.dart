import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class MyBillPage extends StatefulWidget {
  final Widget child;

  MyBillPage({Key key, this.child}) : super(key: key);

  _MyBillPageState createState() => _MyBillPageState();
}

class _MyBillPageState extends State<MyBillPage> {
  @override
  Widget build(BuildContext context) {
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
        // appBar: AppBar(
        //   elevation: 0,
        //   bottom: DateBar(),
        // ),
        body: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          child: ListView(
            children: <Widget>[
              IncomeComparison(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}
