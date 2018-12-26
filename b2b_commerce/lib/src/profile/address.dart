import 'package:flutter/material.dart';
import 'address/address_detail.dart';

class AddressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("地址管理"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddressDetailPage()));
            },
            title: _buildRow("张三", "13660339641", true),
            subtitle: Text("广东省广州市海珠区云顶同创汇"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: _buildRow("里斯", "13660339641", false),
            subtitle: Text("广东省广州市天河区"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: _buildRow("万物", "13660339641", false),
            subtitle: Text("广东省广州市番禺区"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            title: _buildRow("六六", "13660339641", false),
            subtitle: Text("广东省广州市海珠区"),
            trailing: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }

  Widget _buildRow(String name, String telephone, bool isDefaultAddress) {
    if (isDefaultAddress) {
      return Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 22.0),
            child: Column(
              children: <Widget>[
                Text(name),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 22.0),
            child: Column(
              children: <Widget>[
                Text(
                  telephone,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Text(
                  "默认地址",
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 22.0),
            child: Column(
              children: <Widget>[
                Text(name),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 22.0),
            child: Column(
              children: <Widget>[
                Text(
                  telephone,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
