import 'package:core/core.dart';
import 'package:models/models.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';
import 'package:services/src/user/response/b2b_customer_response.dart';

abstract class UserRepository {
  //注册
  Future<String> register({String type, CompanyRegisterDTO form});

  //发送短信验证码
  Future<String> sendCaptcha(String phone);

  //发送短信验证码
  Future<String> sendCaptchaForLogin(String phone);

  //验证验证码是否正确
  Future<bool> validateCaptcha(String phone, String captcha);

  Future<List<UserModel>> list();

  Future<BrandModel> getBrand(String uid);

  Future<FactoryModel> getFactory(String uid);

  //更新品牌
  Future<String> brandUpdate(BrandModel brand);

  //更新工厂
  Future<String> factoryUpdate(FactoryModel factory);

  //更新工厂图文详情
  Future<String> factoryUpdateProfiles(FactoryModel factory);

  //公司认证
  Future<String> applyCertification(CompanyModel form);

  //产业集群类别
  Future<List<LabelModel>> industrialClustersFromLabels();

  //获取所有标签
  Future<List<LabelModel>> labels();

  /// 手机号是否注册
  Future<UserType> phoneExist(String phone);

  //品牌获取工厂供应商列表（品牌端）
  Future<FactoriesResponse> factorySuppliers(Map<String, Object> params);

  //工厂获取品牌合作商列表（工厂端）
  Future<BrandsResponse> brandSuppliers(Map<String, Object> params);

  ///短信验证重置密码
  Future<bool> resetPassword(String phone, String newPassword, String captcha);

  ///重置密码
  Future<bool> resetPasswordByPassword(String old, String password, String uid);

  //获取所有角色
  Future<List<RoleModel>> roles();

  //获取员工列表
  Future<B2BCustomerResponse> employees(Map<String, Object> params,
      dynamic data);

  //获取员工明细
  Future<B2BCustomerModel> getEmployee(String uid);

  //获取员工列表
  Future<String> employeeCreate(B2BCustomerModel model);

  //更新员工列表
  Future<String> employeeUpdate(B2BCustomerModel model, String uid);

  //删除员工列表
  Future<String> employeeDelete(int id);

  ///更新个人资料
  Future<bool> updateUserInfo(String uid, String name, String phone,
      MediaModel media);
}
