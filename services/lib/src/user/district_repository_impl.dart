import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 区
class DistrictRepositoryImpl implements DistrictRepository {
  const DistrictRepositoryImpl();

  @override
  Future<List<DistrictModel>> list(String city) async {
    Response response = await http$.get(Apis.districtsForCity(city));

    return response.data.map<DistrictModel>((m) => DistrictModel.fromJson(m)).toList();
  }
}
