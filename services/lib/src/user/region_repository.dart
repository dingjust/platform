import 'package:dio/dio.dart';
import 'package:models/models.dart';

abstract class RegionRepository {
  Future<Response<List<RegionModel>>> list();
}
