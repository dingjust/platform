import 'package:flutter/material.dart';
import 'change_password.dart';

class AccountSecurityPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('账号与安全'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('修改密码'),
            trailing: Icon(Icons.chevron_right),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
            },
          ),

        ],
      ),
    );
  }
}