import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
class CityRepositoryImpl implements CityRepository {
  final String baseStoreId;

  const CityRepositoryImpl(this.baseStoreId);

  @override
  Future<Response<List<CityModel>>> list(String region) {
    return http$.get<List<CityModel>>(Apis.citiesForRegion(baseStoreId, region));
  }
}
