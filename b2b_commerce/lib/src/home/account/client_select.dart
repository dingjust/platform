import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      '请选择用户身份注册或登陆',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 150,
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
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                    width: 150,
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
              GestureDetector(
                  onTap: () {
                    showMessage(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            '如何选择身份',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          B2BIcons.question,
                          color: Colors.red,
                          size: 18,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void showMessage(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      '如何选择用户身份类型',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: '品牌商：',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '服装品牌商、贴牌贸易商、设计工作室、批发档口、电商网红等，需要在钉单APP寻找优质工厂或者服装款式服务的企业或个人，选择“品牌商”注册。',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: RichText(
                    text: TextSpan(
                        text: '工 厂：',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '服装生产工厂，需要在钉单APP上寻找各类服装加工订单，管理生产进度的企业选择“工厂”注册。',
                              style: TextStyle(color: Colors.black))
                        ]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text('我知道了'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
