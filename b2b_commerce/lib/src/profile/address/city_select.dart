import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'city_district_select.dart';

class CitySelectPage extends StatelessWidget {
  RegionModel region;

  CitySelectPage({@required this.region});

  List<CityModel> citys = <CityModel>[
    CityModel(
      code: "C001",
      name: "广州市",
      region: RegionModel(isocode: "R001"),
    ),
    CityModel(
      code: "C001",
      name: "中山市",
      region: RegionModel(isocode: "R001"),
    ),
    CityModel(
      code: "C001",
      name: "桂林市",
      region: RegionModel(isocode: "R002"),
    ),
    CityModel(
      code: "C001",
      name: "株洲市",
      region: RegionModel(isocode: "R003"),
    ),
    CityModel(
      code: "C001",
      name: "湛江市",
      region: RegionModel(isocode: "R001"),
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
    List<ListTile> tiles = citys.map((city) {
      return ListTile(
        onTap: () {
          _selectDistrict(context,city);
        },
        title: Text(city.name),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

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
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      body: ListView(
        children: tiles,
      ),
    );
  }
}
