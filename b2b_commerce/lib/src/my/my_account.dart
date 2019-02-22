import 'package:flutter/material.dart';

/// 我的账户
class MyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: GestureDetector(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () => Navigator.pop(context),
              ),
              title: Text(
                '我的账户',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              centerTitle: true,
              expandedHeight: 230,
              pinned: true,
              actions: <Widget>[
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Center(
                        child: Text(
                          '提现',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                    }
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
//                  fit: StackFit.expand,
                  children: <Widget>[
                    _buildTopBackgroud(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBackgroud(BuildContext context) {
    return Container(
      child: Center(
        child:  _buildMoney(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ Color.fromRGBO(255, 80, 1, 1),Color.fromRGBO(255, 140, 0, 1)]),
      ),
    );
  }

  Widget _buildMoney(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 120),
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
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
                                color: Colors.white
                            ),
                          )
                      ),
                      Container(
                          child: Text(
                            "987652.00",
                            style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(3),
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  '余额',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
              )
            ],
          )
      ),
    );
  }


}
