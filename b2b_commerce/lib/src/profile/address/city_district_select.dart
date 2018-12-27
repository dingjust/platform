import 'package:flutter/material.dart';

class CityDistrictSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("选择区"),
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
            title: Text("天河区"),
          ),
          ListTile(
            title: Text("黄埔区"),
          ),
          ListTile(
            title: Text("海珠区"),
            selected: true,
          )
        ],
      ),
    );
  }
}
