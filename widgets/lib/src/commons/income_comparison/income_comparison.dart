import 'package:flutter/material.dart';

class IncomeComparison extends StatelessWidget {
  final double height;

  IncomeComparison({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '收入',
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1)),
              ),
              Text(
                '支出',
                style: TextStyle(
                    fontSize: 18, color: Color.fromRGBO(100, 100, 100, 1)),
              )
            ],
          )
        ],
      ),
    );
  }
}
