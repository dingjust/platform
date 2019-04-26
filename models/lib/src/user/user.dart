import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

import 'user_group.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

part 'user.g.dart';

/// 用户
@JsonSerializable()
class UserModel extends PrincipalModel {
  bool loginDisabled;

  /// 用户类型
  UserType type;

  /// 用户状态
  UserStatus status;

  /// 角色
  List<RoleModel> roles;

  /// 公司id
  String companyCode;

  /// 公司名称
  String companyName;

  /// 公司信息
  B2BUnitModel b2bUnit;

  Image get avatar =>
      profilePicture ??
      CachedNetworkImage(
          width: 100,
          height: 100,
          imageUrl: '${profilePicture.url}',
          fit: BoxFit.cover,
          placeholder: (context, url) => SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30,
              ),
          errorWidget: (context, url, error) => SpinKitRing(
                color: Colors.black12,
                lineWidth: 2,
                size: 30,
              ));

  UserModel(
      {MediaModel profilePicture,
      String uid,
      String name,
      this.loginDisabled,
      this.type,
      this.roles,
      this.status,
      this.b2bUnit})
      : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
        );

  UserModel.empty() {
    this.profilePicture = null;
    this.uid = "anonymous";
    this.name = "未登录用户";
    this.loginDisabled = false;
    this.type = UserType.ANONYMOUS;
    this.status = UserStatus.OFFLINE;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  static Map<String, dynamic> toJson(UserModel model) =>
      _$UserModelToJson(model);
}

/// 客户
@JsonSerializable()
class CustomerModel extends UserModel {
  String mobileNumber;

  CustomerModel({
    MediaModel profilePicture,
    String uid,
    String name,
    bool loginDisabled,
    List<RoleModel> roles,
    @required this.mobileNumber,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          loginDisabled: loginDisabled,
          roles: roles,
        );

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  static Map<String, dynamic> toJson(CustomerModel model) =>
      _$CustomerModelToJson(model);
}

/// B2B客户
@JsonSerializable()
class B2BCustomerModel extends CustomerModel {
  bool active;
  B2BUnitModel defaultB2BUnit;

  B2BCustomerModel({
    MediaModel profilePicture,
    String uid,
    String name,
    bool loginDisabled,
    String mobileNumber,
    List<RoleModel> roles,
    this.active,
    this.defaultB2BUnit,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          loginDisabled: loginDisabled,
          mobileNumber: mobileNumber,
          roles: roles,
        );

  factory B2BCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$B2BCustomerModelFromJson(json);

  static Map<String, dynamic> toJson(B2BCustomerModel model) =>
      _$B2BCustomerModelToJson(model);
}

/// 地址
@JsonSerializable()
class AddressModel extends ItemModel {
  String fullname;
  String cellphone;

  @JsonKey(toJson: _regionToJson)
  RegionModel region;

  @JsonKey(toJson: _cityToJson)
  CityModel city;

  @JsonKey(toJson: _cityDistrictToJson)
  DistrictModel cityDistrict;

  String line1;
  bool defaultAddress;

  AddressModel({
    this.fullname,
    this.cellphone,
    this.region,
    this.city,
    this.cityDistrict,
    this.line1,
    this.defaultAddress = false,
  });

  String get regionCityAndDistrict =>
      region.name == city.name && region.name == cityDistrict.name
          ? region.name
          : region.name + city.name + cityDistrict.name;

  String get details =>
      (region.name + city.name + cityDistrict.name + '${line1 ?? ''}');

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  static Map<String, dynamic> toJson(AddressModel model) =>
//      _$AddressModelToJson(model);
      _addressToJson(model);

  static Map<String, dynamic> _regionToJson(RegionModel model) =>
      RegionModel.toJson(model);

  static Map<String, dynamic> _cityToJson(CityModel model) =>
      CityModel.toJson(model);

  static Map<String, dynamic> _cityDistrictToJson(DistrictModel model) =>
      DistrictModel.toJson(model);

  static Map<String, dynamic> _addressToJson(AddressModel model) {
    return {
      'fullname': model.fullname,
      'cellphone': model.cellphone,
      'line1': model.line1,
      'defaultAddress': model.defaultAddress,
      'region': {'isocode': model.region.isocode},
      'city': {'code': model.city.code},
      'cityDistrict': {'code': model.cityDistrict.code}
    };
  }
}

/// 省份
@JsonSerializable()
class RegionModel extends ItemModel {
  String isocode;
  String name;
  String isocodeShort;
  String countryIso;

  RegionModel({this.isocode, this.name, this.isocodeShort, this.countryIso});

  factory RegionModel.fromJson(Map<String, dynamic> json) =>
      _$RegionModelFromJson(json);

  static Map<String, dynamic> toJson(RegionModel model) =>
      _$RegionModelToJson(model);
}

/// 城市
@JsonSerializable()
class CityModel extends ItemModel {
  String code;
  String name;
  @JsonKey(toJson: _regionToJson)
  RegionModel region;

  CityModel({
    @required this.code,
    @required this.name,
    this.region,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  static Map<String, dynamic> toJson(CityModel model) =>
      _$CityModelToJson(model);

  static Map<String, dynamic> _regionToJson(RegionModel model) =>
      RegionModel.toJson(model);
}

/// 地区
@JsonSerializable()
class DistrictModel extends ItemModel {
  String code;
  String name;
  @JsonKey(toJson: _cityToJson)
  CityModel city;

  DistrictModel({@required this.code, @required this.name, this.city});

  factory DistrictModel.fromJson(Map<String, dynamic> json) =>
      _$DistrictModelFromJson(json);

  static Map<String, dynamic> toJson(DistrictModel model) =>
      _$DistrictModelToJson(model);

  static Map<String, dynamic> _cityToJson(CityModel model) =>
      CityModel.toJson(model);
}

///角色
@JsonSerializable()
class RoleModel extends ItemModel {
  String uid;
  String name;

  RoleModel({this.uid, this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

  static Map<String, dynamic> toJson(RoleModel model) =>
      _$RoleModelToJson(model);
}
