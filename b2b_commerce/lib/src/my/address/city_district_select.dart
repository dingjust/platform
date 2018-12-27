import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CityDistrictSelectPage extends StatelessWidget {
  final String code;

  CityDistrictSelectPage(this.code);

  final List<DistrictModel> districts = <DistrictModel>[
    DistrictModel(
      code: 'D001',
      name: '天河区',
    ),
    DistrictModel(
      code: 'D001',
      name: '海珠区',
    ),
    DistrictModel(
      code: 'D001',
      name: '番禺区',
    ),
    DistrictModel(
      code: 'D001',
      name: '黄埔区',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = districts.map((district) {
      return ListTile(
        onTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        title: Text(district.name),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择区'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        children: tiles,
      ),
    );
  }
}
