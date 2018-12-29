import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<MenuItem> list = [
    MenuItem(Icons.phone, '报价管理', null),
    MenuItem(MyIcons.bool, '报价管理', null),
    MenuItem(Icons.phone, '报价管理', null),
    MenuItem(MyIcons.bool, '报价管理', null)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView(
        children: <Widget>[Menu('我的代办', list), Menu('订单管理', list)],
      )),
      backgroundColor: Colors.grey[200],
    );
  }
}

class Menu extends StatelessWidget {
  final String title;
  final List<MenuItem> items;

  Menu(this.title, this.items);

  @override
  Widget build(BuildContext context) {
    List<MenuItem> columns = this.items.map((item) {
      return MenuItem(item.icon, item.title, item.routeTo);
    }).toList();

    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
            child: Text(title, style: TextStyle(fontSize: 16.0)),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: columns,
            ),
          )
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String routeTo;

  MenuItem(this.icon, this.title, this.routeTo);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeTo);
      },
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MyIcons{
  static const IconData bool = const IconData(
      0xe611, 
      fontFamily: 'myIcon', 
      matchTextDirection: true
  );
}
