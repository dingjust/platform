import 'package:models/models.dart';

abstract class UserRepository {
  //注册
  Future<String> register({String type, CompanyRegisterDTO form});

  Future<List<UserModel>> list();

  Future<BrandModel> getBrand(String uid);

  Future<FactoryModel> getFactory(String uid);

  //更新品牌
  Future<String> brandUpdate(BrandModel brand);

  //更新工厂
  Future<String> factoryUpdate(FactoryModel factory);

  //公司认证
  Future<String> applyCertification(CompanyModel form);

  //产业集群类别
  Future<List<LabelModel>> industrialClustersFromLabels();

  //获取所有标签
  Future<List<LabelModel>> labels();
}
