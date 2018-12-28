import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'city_select.dart';

class RegionSelectPage extends StatelessWidget {
  final List<RegionModel> regions = <RegionModel>[
    RegionModel(isocode: 'R001', name: '广东省'),
    RegionModel(isocode: 'R002', name: '广西省'),
    RegionModel(isocode: 'R003', name: '湖南省'),
    RegionModel(isocode: 'R004', name: '湖北省'),
    RegionModel(isocode: 'R005', name: '黑龙江省'),
  ];

  _selectCity(BuildContext context,RegionModel region) async{
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySelectPage(region:region),
      ),
    ) as List;

    result.add(region);

    Navigator.pop(context,result);
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = regions.map((region) {
      return ListTile(
        onTap: () {
          _selectCity(context,region);
        },
        title: Text(region.name),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择省'),
      ),
      body: ListView(
        children: tiles,
      ),
    );
  }
}
