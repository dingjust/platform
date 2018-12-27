import 'package:flutter/material.dart';

class ProfileAboutPage extends StatefulWidget {
  @override
  _ProfileAboutPageState createState() => _ProfileAboutPageState();
}

class _ProfileAboutPageState extends State<ProfileAboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('关于衣加衣'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: AppProfile(icon: Icon(Icons.ac_unit), name: '衣加衣', version: '1.0.0'),
            ),
            AppActions(),
            AppProtocols(),
            AppCopyright()
          ],
        ),
      ),
    );
  }
}

class AppProfile extends StatelessWidget {
  AppProfile({@required this.icon, @required this.name, @required this.version});

  final Icon icon;
  final String name;
  final String version;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          icon,
          Text(this.name),
          Text(this.version),
        ],
      ),
    );
  }
}

class AppActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          trailing: Icon(Icons.chevron_right),
          title: const Text('功能介绍'),
          leading: const Icon(Icons.shopping_basket),
          onTap: () {},
        ),
        ListTile(
          trailing: Icon(Icons.chevron_right),
          title: const Text('版本更新'),
          leading: const Icon(Icons.shopping_basket),
          onTap: () {},
        )
      ],
    );
  }
}

class AppProtocols extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          textColor: Colors.lightBlueAccent,
          child: Text('衣加衣软件许可及使用协议'),
          onPressed: () {},
        ),
      ],
    );
  }
}

class AppCopyright extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('宁波衣加衣 版权所有'),
    );
  }
}
