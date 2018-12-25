import 'package:flutter/material.dart';

import './about.dart';

class ProfileSettingsPage extends StatefulWidget {
  static const String ROUTE_ABOUT = '/about';

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
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
          InkWell(
            onTap: () {},
            child: OutlineButton(
              child: Text(
                '切换账号',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: null,
            ),
          ),
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
