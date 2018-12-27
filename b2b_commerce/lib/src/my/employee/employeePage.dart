import 'package:flutter/material.dart';
import './employeeDetailPage.dart';

const List employeeName = ['Mr.Zhang', 'Mr.Li', 'Mr.Chen'];
const List employeePhone = ['1311111111', '1322222222', '1333333333'];
const List employeePic = [
  'http://www.ffpic.com/files/2014/0829/14061323317269/ffpic1406134712250x10.png',
  'http://www.ffpic.com/files/2014/0829/14061323317269/ffpic140613479723yw23.png',
  'http://www.ffpic.com/files/2014/0829/14061323317269/ffpic1406134724815034.png'
];
const List employeeRule = ['Admin','CEO','CTO'];

List<Widget> _list = new List();

class ProfileEmployeePage extends StatefulWidget {
  @override
  _ProfileEmployeePageState createState() => _ProfileEmployeePageState();
}

class _ProfileEmployeePageState extends State<ProfileEmployeePage> {
  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < employeeName.length; i++) {
      _list.add(buildListData(context, employeeName[i], employeePhone[i],employeePic[i],employeeRule[i]));
    }
//    var divideList = ListTile.divideTiles(context: context, tiles: _list).toList();
    return new Scaffold(
      appBar: AppBar(
        title: const Text('员工管理'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              textDirection: TextDirection.rtl,
            ),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileEmployeeDetailPage(
                      isCreate: true,
                    )
                ),
              );
            },
          )
        ],
      ),
      body: new Scrollbar(
        // ListView.builder 方式
        child: new ListView.builder(
            itemCount: employeeName.length,
            itemBuilder: (context, item) {
              return new Row(children: <Widget>[
                new CircleAvatar(
                  child: new Image.network(
                    employeePic[item],
                  ),
                  radius: 30.0,
                ),
                new Expanded(
                  child: new Column(children: <Widget>[
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          buildListData(
                              context, employeeName[item], employeePhone[item],employeePic[item],employeeRule[item]),
                          new Divider()
                        ],
                      ),
                    )
                  ]),
                  flex: 4,
                )
              ]);
            }),
      ),
    );
  }
}

Widget buildListData(BuildContext context, String strItem, String phoneItem,String picItem,String ruleItem) {
  return new ListTile(
    isThreeLine: false,
    title: new Text(
      strItem,
      style: new TextStyle(
        color: Colors.black54,
        fontSize: 20.0,
      ),
    ),
    subtitle: new Text(phoneItem),
    trailing: new Icon(Icons.keyboard_arrow_right),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileEmployeeDetailPage(
                  name: strItem,
                  phone: phoneItem,
                  pic:picItem,
                  rule:ruleItem
                )),
      );
    },
  );
}

