import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'user_group.dart';

part 'user.g.dart';

/// 用户
@JsonSerializable()
class UserModel extends PrincipalModel {
  bool loginDisabled;
  UserType userType;
  List<RoleModel> roles;

  Image get avatar => profilePicture ?? Image.network(profilePicture);

  UserModel({
    String profilePicture,
    String uid,
    String name,
    this.loginDisabled,
    this.roles,
    this.userType,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
        );

  UserModel.empty() {
    this.profilePicture = null;
    this.uid = "anonymous";
    this.name = "未登录用户";
    this.loginDisabled = false;
    this.userType = UserType.ANONYMOUS;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  static Map<String, dynamic> toJson(UserModel model) => _$UserModelToJson(model);
}

/// 客户
@JsonSerializable()
class CustomerModel extends UserModel {
  String mobileNumber;

  CustomerModel({
    String profilePicture,
    String uid,
    String name,
    bool loginDisabled,
    @required this.mobileNumber,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          loginDisabled: loginDisabled,
        );

  factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  static Map<String, dynamic> toJson(CustomerModel model) => _$CustomerModelToJson(model);
}

/// B2B客户
@JsonSerializable()
class B2BCustomerModel extends CustomerModel {
  bool active;
  B2BUnitModel defaultB2BUnit;

  B2BCustomerModel({
    String profilePicture,
    String uid,
    String name,
    bool loginDisabled,
    String mobileNumber,
    this.active,
    this.defaultB2BUnit,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          loginDisabled: loginDisabled,
          mobileNumber: mobileNumber,
        );

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
  bool defaultAddress;

  AddressModel({
    @required this.fullname,
    @required this.cellphone,
    @required this.region,
    @required this.city,
    @required this.cityDistrict,
    @required this.line1,
    this.defaultAddress = false,
  });
  String get regionCityAndDistrict => region.name == city.name && region.name == cityDistrict.name ? region.name :region.name + city.name + cityDistrict.name;

  String get details => (region.name + city.name + cityDistrict.name + line1);

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  static Map<String, dynamic> toJson(AddressModel model) => _$AddressModelToJson(model);
}

/// 省份
@JsonSerializable()
class RegionModel extends ItemModel {
  String isocode;
  String name;
  String isocodeShort;
  String countryIso;

  RegionModel({this.isocode, this.name, this.isocodeShort, this.countryIso});

  factory RegionModel.fromJson(Map<String, dynamic> json) => _$RegionModelFromJson(json);

  static Map<String, dynamic> toJson(RegionModel model) => _$RegionModelToJson(model);
}

/// 城市
@JsonSerializable()
class CityModel extends ItemModel {
  String code;
  String name;
  RegionModel region;

  CityModel({
    @required this.code,
    @required this.name,
    this.region,
  });

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

///角色
@JsonSerializable()
class RoleModel extends ItemModel{
  String uid;
  String name;

  RoleModel({this.uid,this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);

  static Map<String, dynamic> toJson(RoleModel model) => _$RoleModelToJson(model);
}
