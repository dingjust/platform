import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
class CityRepositoryImpl implements CityRepository {
  final String baseStoreId;

  const CityRepositoryImpl(this.baseStoreId);

  @override
  Future<List<CityModel>> list(String region) async {
    Response response = await http$.get(Apis.citiesForRegion(baseStoreId, region));

    return response.data.map<CityModel>((m) => CityModel.fromJson(m)).toList();
  }
}
