import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CityDistrictSelectPage extends StatelessWidget {
 final CityModel city;

  CityDistrictSelectPage({@required this.city});

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
    List<ListTile> tiles = districts.map((district){
      List result = [district];
      return ListTile(
        onTap: (){
          Navigator.pop(context,result);
        },
        title: Text(district.name),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择区'),
      ),
      body: ListView(
        children: tiles,
      ),
    );
  }
}
