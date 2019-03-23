import 'package:models/models.dart';

abstract class UserRepository {
  Future<List<UserModel>> list();

  Future<BrandModel> getBrand(String uid);

  Future<FactoryModel> getFactory(String uid);

  //公司认证
  Future<String> applyCertification(CompanyModel form);

  Future<String> register({String type, CompanyRegisterDTO form});
}
