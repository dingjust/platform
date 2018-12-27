import 'package:flutter/material.dart';
import 'employeeFormPage.dart';

class ProfileEmployeeDetailPage extends StatelessWidget {
  final String name;
  final String phone;
  final String pic;
  final String rule;
  final bool isCreate;

  ProfileEmployeeDetailPage(
      {Key key, this.name, this.phone, this.pic, this.rule, this.isCreate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(isCreate == true ? '添加' : '详细信息'),
          actions: isCreate == true ? <Widget>[
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.white,
                textDirection: TextDirection.rtl,
              ),
              onPressed: (){
                Navigator.pop(context,null);
              },
            )
          ]:null,
        ),
        body: ListView(
          padding: EdgeInsets.all(20.0),
          children: <Widget>[
            new ListTile(
              title: new Text(
                '头像',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              trailing: isCreate == true ?
              Image.network(
                'https://b-ssl.duitang.com/uploads/item/201704/27/20170427155254_Kctx8.thumb.700_0.jpeg',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ):Image.network(
                '${pic}',
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              onTap: () {},
            ),
            ListTile(
              title: isCreate == true ?
              null:new Text(
                '姓名',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              trailing:isCreate == true ?
              TextField(
                decoration: InputDecoration(
                    labelText: '姓名',
                    hintText: '请输入姓名',
                ),
                obscureText: true,
              ):
              new Text(
                '${name}',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: isCreate == true ?
              null:new Text(
                '手机',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              trailing:isCreate == true ?
              TextField(
                decoration: InputDecoration(
                  labelText: '手机',
                  hintText: '请输入手机',
                ),
                obscureText: true,
                 keyboardType: TextInputType.phone,
              ):
              new Text(
                '${phone}',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: new Text(
                '角色',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                ),
              ),
              trailing:isCreate == true ?Icon(Icons.chevron_right):new Text(
                '${rule}',
                style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileEmployeeFormPage(
                          name: name, phone: phone, pic: pic, rule: rule)),
                );
              },
            )
          ],
        ));
  }
}
