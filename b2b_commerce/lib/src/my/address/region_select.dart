import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'city_select.dart';

class RegionSelectPage extends StatefulWidget {
  final RegionRepository regionRepository;

  RegionSelectPage(this.regionRepository);

  @override
  _RegionSelectPageState createState() => _RegionSelectPageState();
}

class _RegionSelectPageState extends State<RegionSelectPage> {
  _selectCity(BuildContext context, RegionModel region) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySelectPage(region),
      ),
    ) as List;

    result.add(region);

    Navigator.pop(context, result);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('选择省'),
      ),
      body: FutureBuilder<List<RegionModel>>(
        future: widget.regionRepository.list(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((region) {
                return ListTile(
                  onTap: () {
                    _selectCity(context, region);
                  },
                  title: Text(region.name),
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
