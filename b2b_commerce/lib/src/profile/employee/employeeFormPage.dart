import 'package:flutter/material.dart';

class ProfileEmployeeFormPage extends StatefulWidget {
  final String name;
  final String phone;
  final String pic;
  final String rule;

  ProfileEmployeeFormPage({Key key, this.name, this.phone, this.pic, this.rule})
      : super(key: key);

  @override
  _SwitchRouteState createState() => new _SwitchRouteState();
}

class _SwitchRouteState extends State<ProfileEmployeeFormPage> {

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("修改"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                Navigator.pop(context, null);
              },
            )
          ],
        ),
        body: buildListData());
  }

  //ListView的CheckBox
  getList() {
    var ruleList = ['Admin', 'CEO', 'CTO'];
    var selectedRule="";
    Iterable<Widget> listTitles = ruleList.map((String item) {
      return new ListTile(
          isThreeLine: true,
          subtitle: new Text(item,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          trailing: item == widget.rule ?Icon(Icons.check_circle):Icon(Icons.brightness_1),
//          Checkbox(
//              value: item == widget.rule ? true : false,
//              activeColor: Colors.black26, //选中时的颜色
//              onChanged: (value) {
//                setState(() {
//                  _checkboxSelected = value;
//                });
//              })
      );
    });
    return listTitles.toList();
  }

  //创建多种控件，根据传值判断表单页面只需要改什么值
  Widget buildListData() {
    return new ListView(
      padding: EdgeInsets.all(20.0),
      children: this.getList(),
    );
  }
}
