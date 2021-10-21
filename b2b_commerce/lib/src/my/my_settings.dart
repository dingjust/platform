import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/info/info_widgets.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/home/account/login.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './settings/about.dart';
import './settings/account_security.dart';
import 'account/reset_password.dart';

class MySettingsPage extends StatefulWidget {
  @override
  _MySettingsPageState createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  TextStyle labelSytle =
      const TextStyle(fontSize: 14, color: Color(0xFF000000));

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<UserBLoC>(context);

    return Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar('订单明细'),
        bottomNavigationBar: Container(
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: 12,vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(24)),
          child: TextButton(
            onPressed: () {
              bloc.logout(context: context).then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => B2BLoginPage()),
                    ModalRoute.withName('/'));
              });
            },
            child: Text(
              '退出登录',
              style: TextStyle(color: Color(0xFF222222), fontSize: 16),
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.fromLTRB(12, 14, 12, 8),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          children: [
                            Text(
                              '账号与安全',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFAA6E15),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    ListTile(
                      title: Text(
                        '修改密码',
                        style: labelSytle,
                      ),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordPage()));
                      },
                    ),
                    InfoDivider(
                      height: 1,
                    ),
                    ListTile(
                      title: Text('账号注销', style: labelSytle),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.ROUTE_CANCELLATION_ACCOUNT);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.fromLTRB(12, 2, 12, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  trailing: const Icon(Icons.chevron_right),
                  title: const Text('关于钉单'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileAboutPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
