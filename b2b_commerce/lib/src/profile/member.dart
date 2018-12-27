import 'package:flutter/material.dart';
import 'member/memberEditorPage.dart';

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
                  padding: const EdgeInsets.fromLTRB(8.0,20.0,8.0,8.0),
                  child: new ListView(
                    children: <Widget>[
                      new ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'http://jspang.com/static//myimg/blogtouxiang.jpg',
                          ),
                          radius: 30.0,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('小勇 13198765432'),
                            Text('会员等级A')
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_horiz),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MemberEditor()),
                            );
                          },
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