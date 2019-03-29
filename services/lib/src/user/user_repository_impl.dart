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

  @override
  Future<String> brandUpdate(BrandModel brand) async {
    Response response = await http$.put(Apis.brandUpdate(brand.uid),
        data: BrandModel.toJson(brand));
    return response.data;
  }

  @override
  Future<String> factoryUpdate(FactoryModel factory) async {
    Response response = await http$.put(Apis.factoryUpdate(factory.uid),
        data: FactoryModel.toJson(factory));
    return response.data;
  }

  @override
  Future<String> applyCertification(CompanyModel form) async {
    Response response = await http$.put(Apis.applyCertification,
        data: CompanyModel.toJson(form));
    return response.data;
  }

  ///注册
  Future<String> register({String type, CompanyRegisterDTO form}) async {
    Response response;
    try {
      response = await http$.post(UserApis.register(type),
          data: CompanyRegisterDTO.toJson(form));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return 'successful';
    } else {
      return null;
    }
  }

  @override
  Future<List<LabelModel>> industrialClustersFromLabels() async {
    Response response =
        await http$.get(UserApis.getIndustrialClusterFromLabels);
    return response.data
        .map<LabelModel>((label) => LabelModel.fromJson(label))
        .toList();
  }

  @override
  Future<List<LabelModel>> labels() async {
    Response response = await http$.get(UserApis.labels);
    return response.data
        .map<LabelModel>((label) => LabelModel.fromJson(label))
        .toList();
  }

  @override
  Future<bool> phoneExist(String phone) async {
    // TODO: implement phoneExist
    /// 公司订单报表
    Response response;
    try {
      response = await http$.get(UserApis.phonExist(phone));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }
}
