import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:flutter/material.dart';

class AccountSecurityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('账号与安全'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('修改密码'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ResetPasswordPage()));
            },
          ),
        ],
      ),
    );
  }
}
