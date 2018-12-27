import 'package:flutter/material.dart';

class TabbedAppBarSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            centerTitle: true,
            title: Text('会员管理'),
            actions: <Widget>[
              new IconButton( // action button
                icon: Icon(Icons.person_add),
                onPressed: (){},
              ),
            ],
            bottom: new TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return new Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          body: new TabBarView(
            children: choices.map((Choice choice) {
              return new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new ListView(
                    children: <Widget>[
                      new ListTile(
                        leading: Image.network(
                          'http://jspang.com/static//myimg/blogtouxiang.jpg',
                          width: 80.0,
                          height: 80.0,
                        ),
                        title: Text('小勇 会员等级A 13198765432'),
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: (){},
                        ),
                      ),
                    ],
                  )
              );
            }).toList(),
          ),
        ),
      );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '会员信息', icon: Icons.directions_car),
  const Choice(title: '会员审核', icon: Icons.directions_bike),
];