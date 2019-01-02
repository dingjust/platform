import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'region_repository.dart';

class RegionRepositoryImpl implements RegionRepository {
  final String baseStoreId;

  const RegionRepositoryImpl(this.baseStoreId);

  @override
  Future<Response<List<RegionModel>>> list() {
    return http$.get<List<RegionModel>>(Apis.regions(baseStoreId));
  }
}
