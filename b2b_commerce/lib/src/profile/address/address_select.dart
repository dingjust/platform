import 'package:flutter/material.dart';
import 'region_select.dart';

class AddressSelectPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("选择省市区"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegionSelectPage()));
            },
            title: Text("广东省"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegionSelectPage()));
            },
            title: Text("广州市"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegionSelectPage()));
            },
            title: Text("海珠区"),
            trailing: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}