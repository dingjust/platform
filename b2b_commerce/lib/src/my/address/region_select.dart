import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'city_select.dart';

class RegionSelectPage extends StatelessWidget {
  final RegionRepository regionRepository;

  final bool onlySelectRegion;

  RegionSelectPage(this.regionRepository, {this.onlySelectRegion = false});

  _selectCity(BuildContext context, RegionModel region) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySelectPage(region, CityRepositoryImpl()),
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
        title: Text('选择省'),
      ),
      body: FutureBuilder<List<RegionModel>>(
        future: regionRepository.list(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((region) {
                return ListTile(
                  onTap: () {
                    if (onlySelectRegion) {
                      Navigator.pop(context, region);
                    } else {
                      _selectCity(context, region);
                    }
                  },
                  title: Text('${region.name}'),
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
