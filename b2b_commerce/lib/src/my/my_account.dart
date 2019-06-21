import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/account/binding_card_page.dart';
import 'package:b2b_commerce/src/my/account/socket.dart';
import 'package:b2b_commerce/src/my/account/withdraw_cash.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import 'account/amount_flow_list.dart';

/// 我的账户
class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.data != null) {
            return Container(
              color: Color.fromRGBO(245, 245, 245, 1),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    elevation: 0.5,
                    backgroundColor: const Color.fromRGBO(255, 219, 0, 1),
                    centerTitle: true,
                    title: Text(
                      '我的账户',
                      style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1),
                        fontSize: 22,
                      ),
                    ),
                    actions: <Widget>[_buildAction(context)],
                    brightness: Brightness.dark,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[_buildHeader(context)],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                        _buildBill(context),
                        _buildBlankCard(context),
                      ])),
                ],
              ),
            );
          } else {
            return _buildLoadingPage();
          }
        },
        initialData: null,
        future: _getData(),
      ),
      bottomSheet: Container(
        height: 50,
        width: double.infinity,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WithdrawCash()),
            );
          },
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '提现',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: Center(
          child: const Text(
            '交易明细',
            style: const TextStyle(
              color: const Color.fromRGBO(36, 38, 41, 1),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AmountFlowsPage()));
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _buildTotal(),
          Text(
            '总金额',
            style: TextStyle(color: Colors.black45),
          ),
          Divider(
            color: Colors.white,
          ),
          _buildAmountRow()
        ],
      ),
    );
  }

  Widget _buildTotal() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      child: Text(
                        "￥",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(36, 38, 41, 1),
                        ),
                      )),
                  Container(
                      child: Text(
                        "987652.00",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(36, 38, 41, 1),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        AmountBlock(
          amount: 5899.00,
          text: '可取金额',
        ),
        AmountBlock(
          amount: 5899.00,
          text: '提现中金额',
        ),
        AmountBlock(
          amount: 5899.00,
          text: '未结算金额',
        )
      ],
    );
  }

  Widget _buildBill(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                child: Text(
                  "账单",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.black45),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 15),
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
                    ),
                  ),
                ),
                Icon(B2BIcons.del_blank_card)
              ],
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.black26, width: 0.5)),
            padding: EdgeInsets.symmetric(vertical: 10),
            onPressed: onAddCard,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      child: Text(
                        '＋ 添加银行卡',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFFF9516),
                        ),
                      )),
                  Container(
                    child: Text(
                      '支持农行、工行、招行和建行',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildLoadingPage() {
    return Container(
      color: Color.fromRGBO(245, 245, 245, 1),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            elevation: 0.5,
            backgroundColor: const Color.fromRGBO(255, 219, 0, 1),
            centerTitle: true,
            title: Text(
              '我的账户',
              style: TextStyle(
                color: Color.fromRGBO(36, 38, 41, 1),
                fontSize: 22,
              ),
            ),
            actions: <Widget>[_buildAction(context)],
            brightness: Brightness.dark,
          ),
          SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  void onAddCard() {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => BindingCardPage()));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WebSocketRoute()));
  }

  Future<String> _getData() async {
    return Future.delayed(const Duration(seconds: 1), () {
      return '1';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class AmountBlock extends StatelessWidget {
  final String text;

  final double amount;

  final double width;

  final double height;

  const AmountBlock(
      {Key key, this.text, this.amount, this.width = 50, this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '￥$amount',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            '$text',
            style: TextStyle(color: Colors.black54),
          )
        ],
      ),
    );
  }
}
