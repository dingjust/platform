import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'user_group.dart';

part 'user.g.dart';

/// 用户
@JsonSerializable()
class UserModel extends PrincipalModel {
  String password;
  bool loginDisabled;

  UserModel({this.password, this.loginDisabled});

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  static Map<String, dynamic> toJson(UserModel model) => _$UserModelToJson(model);
}

/// 客户
@JsonSerializable()
class CustomerModel extends UserModel {
  CustomerModel();

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  static Map<String, dynamic> toJson(CustomerModel model) => _$CustomerModelToJson(model);
}

/// B2B客户
@JsonSerializable()
class B2BCustomerModel extends UserModel {
  bool active;
  B2BUnitModel defaultB2BUnit;

  B2BCustomerModel({this.active, this.defaultB2BUnit});

  factory B2BCustomerModel.fromJson(Map<String, dynamic> json) => _$B2BCustomerModelFromJson(json);

  static Map<String, dynamic> toJson(B2BCustomerModel model) => _$B2BCustomerModelToJson(model);
}

/// 地址
@JsonSerializable()
class AddressModel extends ItemModel {
  String fullname;
  String cellphone;
  RegionModel region;
  CityModel city;
  DistrictModel cityDistrict;
  String line1;
  String line2;
  bool defaultAddress;

  AddressModel({this.fullname, this.cellphone, this.region, this.city, this.cityDistrict, this.line1, this.line2,this.defaultAddress});

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  static Map<String, dynamic> toJson(AddressModel model) => _$AddressModelToJson(model);
}

/// 省份
@JsonSerializable()
class RegionModel extends ItemModel {
  String isocode;
  String name;

  RegionModel({this.isocode, this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) => _$RegionModelFromJson(json);

  static Map<String, dynamic> toJson(RegionModel model) => _$RegionModelToJson(model);
}

/// 城市
@JsonSerializable()
class CityModel extends ItemModel {
  String code;
  String name;
  RegionModel region;

  CityModel({@required this.code, @required this.name, this.region});

  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);

  static Map<String, dynamic> toJson(CityModel model) => _$CityModelToJson(model);
}

/// 地区
@JsonSerializable()
class DistrictModel extends ItemModel {
  String code;
  String name;
  CityModel city;

  DistrictModel({@required this.code, @required this.name, this.city});

  factory DistrictModel.fromJson(Map<String, dynamic> json) => _$DistrictModelFromJson(json);

  static Map<String, dynamic> toJson(DistrictModel model) => _$DistrictModelToJson(model);
}
