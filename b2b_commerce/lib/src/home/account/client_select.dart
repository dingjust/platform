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
                        Icon(
                          B2BIcons.question,
                          color: Colors.red,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text(
                            '如何选择身份',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
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
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/selectIdentity.txt"),
            initialData: null,
            builder: (context, snapshot) {
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
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
