import 'package:flutter/material.dart';

class MembershipForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text('会员明细'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: '姓名',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '手机号码',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '会员等级',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '公司',
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '地址',
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('历史订单'),
                      Text('查看更多订单>'),
                    ],
                  ),
                  Text('付款人姓名'),
                  Text('付款时间'),
                ],
              ),
            ),
          ],
        ));
  }
}
