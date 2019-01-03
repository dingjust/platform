import 'package:dio/dio.dart';
import 'package:models/models.dart';

/// 省
abstract class RegionRepository {
  Future<Response<List<RegionModel>>> list();
}
