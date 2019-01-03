import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 市
class CityRepositoryImpl implements CityRepository {
  const CityRepositoryImpl();

  @override
  Future<List<CityModel>> list(String region) async {
    Response response = await http$.get(Apis.citiesForRegion(region));

    return response.data.map<CityModel>((m) => CityModel.fromJson(m)).toList();
  }
}
