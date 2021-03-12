import 'package:flutter/material.dart';

class IntegralExchangeSuccessPage extends StatefulWidget {
  @override
  _IntegralExchangeSuccessPageState createState() =>
      _IntegralExchangeSuccessPageState();
}

class _IntegralExchangeSuccessPageState
    extends State<IntegralExchangeSuccessPage> {
  @override
  Widget build(context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              centerTitle: true,
              title: Text('申请成功'),
            ),
            body: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'temp/success.png',
                        package: 'assets',
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('兑换申请已提交，请等待审核'),
                  ),
                  TextButton(
                      // style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Color(0xFFFFD60C))),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('返回')),
                ],
              ),
            )),
        onWillPop: () {
          Navigator.of(context).pop(true);
          return Future.value(false);
        });
  }
}
