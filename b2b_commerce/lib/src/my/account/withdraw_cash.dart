import 'package:flutter/material.dart';

/// 提现页面
class WithdrawCash extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                '提现',
                style: TextStyle(
                  color: Color.fromRGBO(36, 38, 41, 1),
                  fontSize: 22,
                ),
              ),
              brightness: Brightness.dark,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[_buildHeader(context)],
                ),
              ),
            ),
            SliverList(delegate: SliverChildListDelegate([])),
          ],
        ),
      ),
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
            '可取奖金额',
            style: TextStyle(color: Colors.black45),
          ),
          // _buildAmountRow()
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
}
