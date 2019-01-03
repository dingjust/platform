import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// 区
abstract class DistrictRepository {
  Future<Response<List<DistrictModel>>> list(String city);
}
