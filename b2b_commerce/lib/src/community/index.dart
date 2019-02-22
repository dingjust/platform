import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// 论坛主页
class ForumHomePage extends StatefulWidget {
  @override
  _ForumHomePageState createState() => new _ForumHomePageState();
}

class _ForumHomePageState extends State<ForumHomePage> {
  @override
  Widget build(BuildContext context) {
    ListView categories = ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.forum),
          title: Text('版块一'),
          subtitle: Text('版块一的描述信息'),
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          leading: Icon(Icons.forum),
          title: Text('版块二'),
          subtitle: Text('版块二的描述信息'),
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          leading: Icon(Icons.forum),
          title: Text('版块三'),
          subtitle: Text('版块三的描述信息'),
          trailing: Icon(Icons.arrow_right),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          tooltip: '搜索',
          icon: Icon(B2BIcons.search,size: 20,),
          onPressed: () {},
        ),
      ),
      body: categories,
    );
  }
}
