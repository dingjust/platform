import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// 区
abstract class DistrictRepository {
  Future<List<DistrictModel>> list(String city);
}
