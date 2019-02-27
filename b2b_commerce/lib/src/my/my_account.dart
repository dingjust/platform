import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/account/withdraw_cash.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// 我的账户
class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
      children: <Widget>[
        _buildTopBackgroud(context),
        _buildBill(context),
        _buildBlankCard(context),
      ],
    )));
  }

  Widget _buildTopBackgroud(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Center(
          child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(
                      child: IconButton(
                    icon: Icon(Icons.chevron_left),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
                  Expanded(
                      child: Center(
                    child: Container(
                      padding: EdgeInsets.only(right: 30),
                      child: Text(
                        '我的账户',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  )),
                  GestureDetector(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Center(
                          child: Text(
                            '提现',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WithdrawCash(),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      child: Text(
                    "￥",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )),
                  Container(
                      child: Text(
                    "987652.00",
                    style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ))
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 50),
            child: Text(
              '余额',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          )
        ],
      )),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(255, 80, 1, 1),
          Color.fromRGBO(255, 140, 0, 1)
        ]),
      ),
    );
  }

  Widget _buildBill(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Text(
                    "账单",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  )),
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          '本月收支',
                          style: TextStyle(fontSize: 20),
                        )),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  IncomeComparison(
                    height: 120,
                    income: 123456.00,
                    expenditure: 789456.00,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.ROUTE_MY_BILL);
            },
          )
        ],
      ),
    );
  }

  Widget _buildBlankCard(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: Text(
                    "银行卡",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551089271298&di=e86274438d3c8ad92d09a82c412f7eb4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f2b45541ad67000001a64b30c1bf.jpg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 150,
                                      child: Text(
                                        '工商银行',
                                      ),
                                    ),
                                    Container(
                                      child: Text('6212***************4243'),
                                    )
                                  ],
                                ),
                              ))),
                      IconButton(
                        icon: Icon(B2BIcons.del_blank_card),
                        tooltip: '删除银行卡',
                      )
                    ],
                  ),
                ),
                Container(
//                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Text(
                          '＋ 添加银行卡',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xFFFF9516),
                          ),
                        )),
                        Container(
                          child: Text(
                            '支持农行、工行、招行和建行',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26, width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          )
        ],
      ),
    );
  }
}
