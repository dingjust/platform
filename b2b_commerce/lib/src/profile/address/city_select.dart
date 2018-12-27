import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'city_district_select.dart';

class CitySelectPage extends StatelessWidget {
  String code;

  CitySelectPage(this.code);

  List<CityModel> citys = <CityModel>[
    CityModel(
      code: "C001",
      name: "广州市",
      region: RegionModel(isocode: "R001"),
    ),
    CityModel(
      code: "C001",
      name: "中山市",
    ),
    CityModel(
      code: "C001",
      name: "佛山市",
    ),
    CityModel(
      code: "C001",
      name: "清远市",
    ),
    CityModel(
      code: "C001",
      name: "湛江市",
    ),

  ];

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = citys.map((city) {
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CityDistrictSelectPage(city.code),
            ),
          );
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
