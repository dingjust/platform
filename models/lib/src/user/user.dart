import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends PrincipalModel {
  String password;
  bool loginDisabled;

  UserModel(String uid, String name) : super(uid) {
    this.uid = uid;
    this.name = name;
    this.loginDisabled = loginDisabled;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  static Map<String, dynamic> toJson(UserModel model) => _$UserModelToJson(model);
}

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

  AddressModel({this.fullname, this.cellphone, this.region, this.city, this.cityDistrict, this.line1, this.line2});

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  static Map<String, dynamic> toJson(AddressModel model) => _$AddressModelToJson(model);
}

@JsonSerializable()
class RegionModel extends ItemModel {
  String isocode;
  String name;

  RegionModel({this.isocode, this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) => _$RegionModelFromJson(json);

  static Map<String, dynamic> toJson(RegionModel model) => _$RegionModelToJson(model);
}

@JsonSerializable()
class CityModel extends ItemModel {
  String code;
  String name;

  CityModel({this.code, this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);

  static Map<String, dynamic> toJson(CityModel model) => _$CityModelToJson(model);
}

@JsonSerializable()
class DistrictModel extends ItemModel {
  String code;
  String name;

  DistrictModel({this.code, this.name});

  factory DistrictModel.fromJson(Map<String, dynamic> json) => _$DistrictModelFromJson(json);

  static Map<String, dynamic> toJson(DistrictModel model) => _$DistrictModelToJson(model);
}
