import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'city_district_select.dart';

class CitySelectPage extends StatelessWidget {
  CitySelectPage(this.region);

  final RegionModel region;
  final List<CityModel> cities = <CityModel>[
    CityModel(
      code: 'C001',
      name: '广州市',
      region: RegionModel(isocode: 'R001'),
    ),
    CityModel(
      code: 'C001',
      name: '中山市',
    ),
    CityModel(
      code: 'C001',
      name: '佛山市',
    ),
    CityModel(
      code: 'C001',
      name: '清远市',
    ),
    CityModel(
      code: 'C001',
      name: '湛江市',
    ),
  ];

  _selectDistrict(BuildContext context, CityModel city) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDistrictSelectPage(city: city),
      ),
    ) as List;

    result.add(city);

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final List<ListTile> _items = cities.map((city) {
      return ListTile(
        onTap: () {
          _selectDistrict(context, city);
        },
        title: Text(city.name),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择市'),
      ),
      body: ListView(
        children: _items,
      ),
    );
  }
}
