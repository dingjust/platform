import 'package:flutter/material.dart';

class IncomeComparison extends StatelessWidget {
  final double height;

  ///收入
  final double income;

  ///支出
  final double expenditure;

  ///对比条高度
  final double lineHeight;

  IncomeComparison(
      {Key key,
      this.height,
      this.income,
      this.expenditure,
      this.lineHeight = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double flex2 = expenditure / income;
    print(flex2);
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '￥${income}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '￥${expenditure}',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: income.toInt(),
                child: Container(
                  height: lineHeight,
                  margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Color.fromRGBO(255, 149, 22, 1),
                      Color.fromRGBO(255, 199, 49, 1)
                    ]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                ),
              ),
              Expanded(
                flex: expenditure.toInt(),
                child: Container(
                    height: lineHeight,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                          Color.fromRGBO(118, 110, 147, 1),
                          Color.fromRGBO(77, 68, 89, 1)
                        ]),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10)))),
              )
            ],
          )
        ],
      ),
    );
  }
}
