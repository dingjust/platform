import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:services/src/api/auth.dart';
import 'package:services/src/home/factory/response/factory_response.dart';
import 'package:services/src/supplier/brands_response.dart';
import 'package:services/src/user/response/b2b_customer_response.dart';

import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl();

  @override
  Future<String> sendCaptcha(String phone) async {
    Response response = await http$.get(UserApis.sendCaptcha(phone),
        options: Options(headers: {'ignoreHeader': true}));
    return response.data;
  }

  @override
  Future<String> sendCaptchaForLogin(String phone) async {
    Response response = await http$.get(UserApis.sendCaptchaForLogin(phone));
    return response.data;
  }

  @override
  Future<bool> validateCaptcha(String phone, String captcha) async {
    Response response = await http$.get(UserApis.validateCaptcha, data: {
      'phone': phone,
      'captcha': captcha,
    });
    return response.data;
  }

  @override
  Future<List<UserModel>> list() {
    return null;
  }

  Future<BrandModel> getBrand(String uid) async {
    Response response;
    try {
      response = await http$.get(Apis.brand(uid));
    } on DioError catch (e) {
      print(e);
    }

    if (response != null && response.statusCode == 200) {
      return BrandModel.fromJson(response.data);
    } else {
      return null;
    }
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

  Future<bool> brandUpdateContact(BrandModel brand) async {
    Response response;
    try {
      response = await http$.put(Apis.brandUpdate(brand.uid),
          data: BrandModel.toJson(brand));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> factoryUpdateContact(FactoryModel factory) async {
    Response response;
    try {
      response = await http$.put(Apis.factoryUpdate(factory.uid),
          data: FactoryModel.toJson(factory));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> factoryUpdate(FactoryModel factory) async {
    Response response = await http$.put(Apis.factoryUpdate(factory.uid),
        data: FactoryModel.toJson(factory));
    return response.data;
  }

  @override
  Future<String> factoryUpdateProfiles(FactoryModel factory) async {
    Response response = await http$.put(Apis.factoryUpdateProfiles(factory.uid),
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
  Future<UserType> phoneExist(String phone) async {
    // TODO: implement phoneExist
    /// 公司订单报表
    Response response;
    try {
      response = await http$.get(UserApis.phoneExists(phone),
          options: Options(headers: {'ignoreHeader': true}));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return UserTypeValueMap[response.data];
    } else {
      return null;
    }
  }

  @override
  Future<BrandsResponse> brandSuppliers(Map<String, Object> params) async {
    Response response = await http$.get(
      Apis.brandsSuppliers,
      data: params,
    );
    return BrandsResponse.fromJson(response.data);
  }

  @override
  Future<FactoriesResponse> factorySuppliers(Map<String, Object> params) async {
    Response response = await http$.get(
      Apis.factorySuppliers,
      data: params,
    );
    return FactoriesResponse.fromJson(response.data);
  }

  @override
  Future<bool> resetPassword(
      String phone, String newPassword, String captcha) async {
    Response response;
    try {
      response = await http$.put(UserApis.resetPassword(phone),
          data: {"newPassword": newPassword, "captcha": captcha});
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<RoleModel>> roles() async {
    Response response = await http$.get(UserApis.roles);
    return response.data
        .map<RoleModel>((role) => RoleModel.fromJson(role))
        .toList();
  }

  @override
  Future<String> employeeCreate(B2BCustomerModel model) async {
    print('${B2BCustomerModel.toJson(model)}');
    Response response;
    String result;
    try {
      response = await http$.post(
        UserApis.employeeCreate,
        data: B2BCustomerModel.toJson(model),
      );
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = response.data;
    }

    return result;
  }

  @override
  Future<String> employeeUpdate(B2BCustomerModel model, String uid) async {
    Response response;
    String result;
    try {
      response = await http$.put(
        UserApis.employeeFromId(uid),
        data: B2BCustomerModel.toJson(model),
      );
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = response.data;
    }

    return result;
  }

  @override
  Future<String> employeeDelete(int id) async {
    Response response;
    String result;
    try {
      response = await http$.delete(UserApis.employeeFromId(id));
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = response.data;
    }

    return result;
  }

  @override
  Future<B2BCustomerResponse> employees(
      Map<String, Object> params, dynamic data) async {
    Response response;
    B2BCustomerResponse result;
    try {
      response = await http$.post(UserApis.employees,
          queryParameters: params, data: data);
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = B2BCustomerResponse.fromJson(response.data);
    }

    return result;
  }

  @override
  Future<B2BCustomerModel> getEmployee(String uid) async {
    Response response;
    B2BCustomerModel result;
    try {
      response = await http$.get(UserApis.employeeFromId(uid));
    } catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = B2BCustomerModel.fromJson(response.data);
    }

    return result;
  }

  @override

  /// 更新用户资料
  Future<bool> updateUserInfo(
      String uid, String name, String phone, MediaModel media) async {
    Response response;
    bool result;
    Map data = {
      'name': name,
      'contactPhone': phone,
    };
    if (media != null) {
      data['profilePicture'] = MediaModel.toJson(media);
    }

    try {
      response = await http$.put(UserApis.updateUserInfo(uid), data: data);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  @override
  Future<bool> resetPasswordByPassword(
      String old, String password, String uid) async {
    Response response;
    try {
      response = await http$.put(UserApis.resetPasswordByPassword(uid),
          queryParameters: {"old": old, "new": password});
    } on DioError catch (e) {
      print(e);
      return false;
    }
    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<BaseResponse> bindingRegister(
      {String type, CompanyRegisterDTO form}) async {
    Response response;
    try {
      response = await http$.post(AuthApis.bindingRegister(type),
          data: CompanyRegisterDTO.toJson(form));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///验证码登录(含子账号)
  static Future<BaseResponse> loginByCaptcha(String phone) async {
    Response response;
    try {
      http$.removeAuthorization();
      response = await http$.get(
        UserApis.loginByCaptcha(phone),
      );
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///验证验证码并返回所有账号
  static Future<BaseResponse> validateCaptchaAccount(
      String phone, String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.validateCaptchaAccount(phone, code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///选择登录账号
  static Future<BaseResponse> selectLoginAccount(
      String phone, String uid, String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.selectLoginAccount(phone, uid, code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///获取提交的修改资料
  static Future<BaseResponse> getFactoryProfileBackup(String code) async {
    Response response;
    try {
      response = await http$.get(UserApis.factoryProfileBackup(code));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///获取当前用户手机所有账号
  static Future<BaseResponse> getRelationAccounts() async {
    Response response;
    try {
      response = await http$.get(UserApis.relationAccounts);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///切换账号
  static Future<BaseResponse> switchAccount(dynamic uid) async {
    Response response;
    try {
      response = await http$.get(UserApis.switchAccount(uid));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///注销账号
  static Future<BaseResponse> accountCancellation() async {
    Response response;
    try {
      response = await http$.get(UserApis.accountCancellation);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///注销状态
  static Future<BaseResponse> cancellationState() async {
    Response response;
    try {
      response = await http$.get(UserApis.cancellationState);
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }

  ///一键注册
  static Future<BaseResponse> defaultRegister(String phone, String code) async {
    Response response;
    try {
      response = await http$.post(UserApis.defaultRegister(phone, code),
          options: Options(receiveTimeout: 30000, sendTimeout: 30000));
    } on DioError catch (e) {
      print(e);
    }
    if (response != null && response.statusCode == 200) {
      return BaseResponse.fromJson(response.data);
    } else {
      return null;
    }
  }
}

class ModelData<T> {
  bool isTimeOut;
  T t;
}
