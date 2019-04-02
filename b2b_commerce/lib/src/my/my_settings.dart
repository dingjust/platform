import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './settings/about.dart';
import './settings/account_security.dart';
import '../business/orders/requirement_order_filter.dart';

class MySettingsPage extends StatefulWidget {
  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<UserBLoC>(context);

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
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            title: const Text('工厂需求订单筛选条件'),
            leading: const Icon(Icons.lock),
            onTap: () async {
              Map<String, Object> map = Map();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RequirementOrderFilterPage(map)),
              );
              // print(map);
            },
          ),
          InkWell(
            onTap: () {},
            child: OutlineButton(
              child: Text(
                '退出登录',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                bloc.logout();
              },
            ),
          ),
        ],
      ),
    );
  }
}
