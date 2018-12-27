import 'package:flutter/material.dart';

class RegionSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("选择省"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("湖南省"),
          ),
          ListTile(
            title: Text("安徽省"),
          ),
          ListTile(
            title: Text("广东省"),
            selected: true,
          )
        ],
      ),
    );
  }
}
