import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 区
class DistrictRepositoryImpl implements DistrictRepository {
  final String baseStoreId;

  const DistrictRepositoryImpl(this.baseStoreId);

  @override
  Future<List<DistrictModel>> list(String city) async {
    Response response = await http$.get(Apis.districtsForCity(baseStoreId, city));

    return response.data.map<DistrictModel>((m) => DistrictModel.fromJson(m)).toList();
  }
}
