import 'package:b2b_commerce/src/business/orders/proofing_order_form.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_filter.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
                  MaterialPageRoute(
                      builder: (context) => RequirementOrderFilterPage(map)));
              print(map);
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            title: const Text('创建打样订单'),
            leading: const Icon(Icons.shopping_basket),
            onTap: () {
              ProofingModel proofing = ProofingModel(
                  belongTo: BrandModel(
//                      profilePicture:
//                          'http://down.52pk.com/uploads/190218/5039_164753_4095.jpg',
                      name: '森马集团有限公司'));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProofingOrderFormPage(proofing)),
              );
            },
          ),
          ListTile(
            trailing: const Icon(Icons.chevron_right),
            title: const Text('工厂所有需求页面'),
            leading: const Icon(Icons.local_convenience_store),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RequirementPoolAllPage()),
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
