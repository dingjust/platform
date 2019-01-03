import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class CityDistrictSelectPage extends StatelessWidget {
  CityDistrictSelectPage(this.city, this.districtRepository);

  final CityModel city;
  final DistrictRepository districtRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择区'),
      ),
      body: FutureBuilder<List<DistrictModel>>(
        future: districtRepository.list(city.code),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((district) {
                return ListTile(
                  onTap: () {
                    district.city = city;
                    Navigator.pop(context, district);
                  },
                  title: Text(district.name),
                  trailing: Icon(Icons.chevron_right),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
