import 'package:models/models.dart';

abstract class UserRepository {
  Future<List<UserModel>> list();

  Future<BrandModel> getBrand(String uid);

  Future<FactoryModel> getFactory(String uid);

  Future<String> register({String type, CompanyRegisterDTO form});
}
