import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'city_district_select.dart';

class CitySelectPage extends StatelessWidget {
  CitySelectPage(this.region, this.cityRepository);

  final RegionModel region;
  final CityRepository cityRepository;

  _selectDistrict(BuildContext context, CityModel city) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDistrictSelectPage(city, DistrictRepositoryImpl()),
      ),
    ) as DistrictModel;

    if (result == null) {
      return;
    }

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择市'),
      ),
      body: FutureBuilder<List<CityModel>>(
        future: cityRepository.list(region.isocode),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((city) {
                return ListTile(
                  onTap: () {
                    city.region = region;
                    _selectDistrict(context, city);
                  },
                  title: Text(city.name),
                  trailing: Icon(Icons.chevron_right),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return ProgressIndicatorFactory.buildDefaultProgressIndicator();
        },
      ),
    );
  }
}
