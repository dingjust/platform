import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';

import 'settings/about.dart';
import 'settings/account_security.dart';

class MySettingsPage extends StatefulWidget {
  static const String ROUTE_ABOUT = '/about';

  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            title: const Text('账号与安全'),
            leading: const Icon(Icons.lock),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSecurityPage()),
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            title: const Text('关于衣加衣'),
            leading: const Icon(Icons.shopping_basket),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileAboutPage()),
              );
            },
          ),
//          InkWell(
//            onTap: () {},
//            child: OutlineButton(
//              child: Text(
//                '切换账号',
//                style: TextStyle(color: Colors.red),
//              ),
//              onPressed: () {
//                Navigator.pushNamed(context, AppRoutes.ROUTE_LOGIN);
//              },
//            ),
//          ),
          InkWell(
            onTap: () {},
            child: OutlineButton(
              child: Text(
                '退出登录',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: null,
            ),
          ),
        ],
      ),
    );
  }
}
