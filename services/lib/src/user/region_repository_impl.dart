import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'region_repository.dart';

/// 省
class RegionRepositoryImpl implements RegionRepository {
  const RegionRepositoryImpl();

  @override
  Future<List<RegionModel>> list() async {
    Response response = await http$.get(Apis.regions());

    return response.data.map<RegionModel>((m) => RegionModel.fromJson(m)).toList();
  }
}
