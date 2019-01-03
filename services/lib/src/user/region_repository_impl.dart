import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'dart:convert';

import 'region_repository.dart';

/// 省
class RegionRepositoryImpl implements RegionRepository {
  final String baseStoreId;

  const RegionRepositoryImpl(this.baseStoreId);

  @override
  Future<List<RegionModel>> list() async {
    Response response = await http$.get(Apis.regions(baseStoreId));

    return response.data.map<RegionModel>((m) => RegionModel.fromJson(m)).toList();
  }
}
