import 'package:models/models.dart';

/// 省
abstract class RegionRepository {
  Future<List<RegionModel>> list();
}
