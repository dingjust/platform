import 'package:models/models.dart';

abstract class OrderRepository {
  Future<String> publishNewRequirement(RequirementOrderModel form);



}
