import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'address/address_form.dart';

class AddressPage extends StatelessWidget {
  final List<AddressModel> addresses = <AddressModel>[
    AddressModel(
      fullname: "华安",
      cellphone: "13660339514",
      region: RegionModel(name: "广东省"),
      city: CityModel(name: "广州市"),
      cityDistrict: DistrictModel(name: "海珠区"),
      line1: "云顶同创汇A01",
      defaultAddress: true,
    ),
    AddressModel(
      fullname: "秋香",
      cellphone: "15902090000",
      region: RegionModel(name: "广东省"),
      city: CityModel(name: "广州市"),
      cityDistrict: DistrictModel(name: "黄埔区"),
      line1: "云顶同创汇C01",
      defaultAddress: false,
    ),
    AddressModel(
      fullname: "梁非凡",
      cellphone: "15902090000",
      region: RegionModel(name: "湖南省"),
      city: CityModel(name: "株洲市"),
      cityDistrict: DistrictModel(name: "株洲区"),
      line1: "云顶同创汇F01",
      defaultAddress: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<ListTile> tiles = this.addresses.map((address) {
      return ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddressFormPage(address: address),
            ),
          );
        },
        title: _buildRow(
          address.fullname,
          address.cellphone,
          address.defaultAddress,
        ),
        subtitle: Text(address.region.name +
            address.city.name +
            address.cityDistrict.name +
            address.line1),
        trailing: Icon(Icons.chevron_right),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("地址管理"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddressFormPage()),
              );
            },
          )
        ],
      ),
      body: ListView(children: tiles),
    );
  }

  Widget _buildRow(String name, String telephone, bool isDefaultAddress) {
    List<Container> containers = <Container>[
      Container(
        padding: EdgeInsets.only(right: 22.0),
        child: Column(
          children: <Widget>[
            Text(name),
          ],
        ),
      ),
      Container(
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
    ];

    if (isDefaultAddress) {
      containers.add(
        Container(
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
      );
    }

    return Row(children: containers);
  }
}
