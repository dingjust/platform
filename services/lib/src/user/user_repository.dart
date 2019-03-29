import 'package:models/models.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';

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

  /// 手机号是否注册
  Future<bool> phoneExist(String phone);

  //品牌获取工厂供应商列表（品牌端）
  Future<FactoriesResponse> factorySuppliers(Map<String,Object> params);

  //工厂获取品牌合作商列表（工厂端）
  Future<BrandsResponse> brandSuppliers(Map<String,Object> params);
}
