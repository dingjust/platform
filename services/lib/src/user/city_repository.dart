import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// 市
abstract class CityRepository {
  Future<Response<List<CityModel>>> list(String region);
}
