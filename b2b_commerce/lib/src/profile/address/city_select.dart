import 'package:flutter/material.dart';

class CitySelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("选择市"),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("深圳市"),
          ),
          ListTile(
            title: Text("汕头市"),
          ),
          ListTile(
            title: Text("广州市"),
            selected: true,
          )
        ],
      ),
    );
  }
}
