import 'package:flutter/material.dart';
import 'address_select.dart';

class AddressDetailPage extends StatefulWidget {
  bool isCreateOnly;

  AddressDetailPage(this.isCreateOnly);

  @override
  AddressDetailState createState() => AddressDetailState();
}

class AddressDetailState extends State<AddressDetailPage> {
  bool _isDefault = false;

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = <ListTile>[
      ListTile(
        title: TextFormField(
          initialValue: "张三",
          decoration: InputDecoration(labelText: "联系人"),
        ),
      ),
      ListTile(
        title: TextFormField(
          initialValue: "13660339641",
          decoration: InputDecoration(labelText: "联系号码"),
        ),
      ),
      ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddressSelectPage()));
        },
        title: Text(
          "省市区",
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
        subtitle: Text(
          "广东省广州市海珠区",
          style: TextStyle(color: Colors.black),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
      ListTile(
        title: TextFormField(
          initialValue: "云顶同创汇",
          decoration: InputDecoration(
              labelText: "详细地址", hintText: "道路、门牌号、小区、楼栋号、单元室等"),
        ),
      ),
      ListTile(
        title: Text("设为默认地址"),
        trailing: Switch(
            value: _isDefault,
            activeColor: Colors.pink,
            onChanged: (bool val) {
              this.setState(() {
                _isDefault = !_isDefault;
              });
            }),
      ),
    ];

    if (widget.isCreateOnly) {
      tiles.add(
        ListTile(
          title: RaisedButton(
            child: Text("删除地址"),
            color: Colors.red,
            onPressed: () {},
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("编辑地址"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: tiles,
      ),
    );
  }
}
