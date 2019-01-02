import 'package:models/models.dart';

abstract class UserRepository {
  Future<List<UserModel>> list();
}
