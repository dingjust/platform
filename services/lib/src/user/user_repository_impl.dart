import 'package:models/models.dart';
import 'package:services/services.dart';
import 'user_repository.dart';
import 'package:dio/dio.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl();

  @override
  Future<List<UserModel>> list() {
    return null;
  }

  Future<BrandModel> getBrand(String uid) async {
    Response response = await http$.get(Apis.brand(uid));
    return BrandModel.fromJson(response.data);
  }

  Future<FactoryModel> getFactory(String uid) async {
    Response response = await http$.get(Apis.factory(uid));
    return FactoryModel.fromJson(response.data);
  }
}
