import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

/// 区
class DistrictRepositoryImpl implements DistrictRepository {
  final String baseStoreId;

  const DistrictRepositoryImpl(this.baseStoreId);

  @override
  Future<Response<List<DistrictModel>>> list(String city) {
    return http$.get<List<DistrictModel>>(Apis.districtsForCity(baseStoreId, city));
  }
}
