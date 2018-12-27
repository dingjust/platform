import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_group.g.dart';

/// 用户组
@JsonSerializable()
class UserGroupModel extends PrincipalGroupModel {
  UserGroupModel();

  factory UserGroupModel.fromJson(Map<String, dynamic> json) => _$UserGroupModelFromJson(json);

  static Map<String, dynamic> toJson(UserGroupModel model) => _$UserGroupModelToJson(model);
}

/// 公司
@JsonSerializable()
class CompanyModel extends UserGroupModel {
  CompanyModel();

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyModel model) => _$CompanyModelToJson(model);
}

@JsonSerializable()
class OrgUnitModel extends CompanyModel {
  OrgUnitModel();

  factory OrgUnitModel.fromJson(Map<String, dynamic> json) => _$OrgUnitModelFromJson(json);

  static Map<String, dynamic> toJson(OrgUnitModel model) => _$OrgUnitModelToJson(model);
}

@JsonSerializable()
class B2BUnitModel extends OrgUnitModel {
  bool active;
  String path;

  B2BUnitModel({this.active, this.path});

  factory B2BUnitModel.fromJson(Map<String, dynamic> json) => _$B2BUnitModelFromJson(json);

  static Map<String, dynamic> toJson(B2BUnitModel model) => _$B2BUnitModelToJson(model);
}

@JsonSerializable()
class BrandModel extends B2BUnitModel {}

@JsonSerializable()
class FactoryModel extends B2BUnitModel {}
