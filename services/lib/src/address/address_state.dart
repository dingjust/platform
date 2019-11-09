import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:models/models.dart';

class AddressState {
  List<RegionModel> _regions;

  Future<List<RegionModel>> getRegions() async {
    if (_regions == null) {
      //获取所有省份
      String str = await rootBundle.loadString('data/province.json');
      List data = json.decode(str);
      _regions = data
          .map<RegionModel>((region) => RegionModel.fromJson(region))
          .toList();
      return _regions;
    } else {
      return _regions;
    }
  }
}
