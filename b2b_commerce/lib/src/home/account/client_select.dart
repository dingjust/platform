import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

class ClientSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'temp/client_select.png',
                package: 'assets',
                fit: BoxFit.fitWidth,
              ),
              Text(
                '请选择用户身份注册或登陆',
                style: TextStyle(fontSize: 16),
              ),
              Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () {
                    UserBLoC.instance.changeUserType(UserType.BRAND);
                  },
                  child: Text(
                    '品牌',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Text(
                '批发商、零售商',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                width: 300,
                height: 50,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: () {
                    UserBLoC.instance.changeUserType(UserType.FACTORY);
                  },
                  child: Text(
                    '工厂',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
