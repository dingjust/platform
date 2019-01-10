import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_group.g.dart';

/// 用户组
@JsonSerializable()
class UserGroupModel extends PrincipalGroupModel {
  UserGroupModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
        );

  factory UserGroupModel.fromJson(Map<String, dynamic> json) => _$UserGroupModelFromJson(json);

  static Map<String, dynamic> toJson(UserGroupModel model) => _$UserGroupModelToJson(model);
}

/// 公司
@JsonSerializable()
class CompanyModel extends UserGroupModel {
  /// 星级
  int starLevel;
  AddressModel contactAddress;

  CompanyModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
    this.starLevel,
    this.contactAddress,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
        );

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyModel model) => _$CompanyModelToJson(model);
}

@JsonSerializable()
class OrgUnitModel extends CompanyModel {
  String path;

  OrgUnitModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
    int starLevel,
    AddressModel contactAddress,
    this.path,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          starLevel: starLevel,
          contactAddress: contactAddress,
        );

  factory OrgUnitModel.fromJson(Map<String, dynamic> json) => _$OrgUnitModelFromJson(json);

  static Map<String, dynamic> toJson(OrgUnitModel model) => _$OrgUnitModelToJson(model);
}

@JsonSerializable()
class B2BUnitModel extends OrgUnitModel {
  bool active;

  B2BUnitModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
    String path,
    int starLevel,
    AddressModel contactAddress,
    this.active,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          starLevel: starLevel,
          contactAddress: contactAddress,
        );

  factory B2BUnitModel.fromJson(Map<String, dynamic> json) => _$B2BUnitModelFromJson(json);

  static Map<String, dynamic> toJson(B2BUnitModel model) => _$B2BUnitModelToJson(model);
}

@JsonSerializable()
class BrandModel extends B2BUnitModel {
  BrandModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
    String path,
    bool active,
    int starLevel,
    AddressModel contactAddress,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          active: active,
          starLevel: starLevel,
          contactAddress: contactAddress,
        );

  factory BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);

  static Map<String, dynamic> toJson(BrandModel model) => _$BrandModelToJson(model);
}

@JsonSerializable()
class FactoryModel extends B2BUnitModel {
  /// 历史接单数
  int historyOrdersCount;

  /// 接单成功率
  double orderedSuccessRate;

  FactoryModel({
    String profilePicture,
    String uid,
    String name,
    PrincipalModel members,
    String path,
    bool active,
    int starLevel,
    AddressModel contactAddress,
    this.historyOrdersCount,
    this.orderedSuccessRate,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          members: members,
          path: path,
          active: active,
          starLevel: starLevel,
          contactAddress: contactAddress,
        );

  factory FactoryModel.fromJson(Map<String, dynamic> json) => _$FactoryModelFromJson(json);

  static Map<String, dynamic> toJson(FactoryModel model) => _$FactoryModelToJson(model);
}
