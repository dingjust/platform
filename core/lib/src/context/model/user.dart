import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String username;

  User(this.username);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  static empty() {}
}

enum UserType {
  /// 匿名用戶
  ANONYMOUS,

  /// 品牌用户
  BRAND,

  /// 工厂用户
  FACTORY,
  DEFAULT,
  CUSTOMER
}

const UserTypeMap = {
  UserType.ANONYMOUS: "ANONYMOUS",
  UserType.BRAND: "BRAND",
  UserType.FACTORY: "FACTORY",
  UserType.DEFAULT: "DEFAULT",
  UserType.CUSTOMER: "CUSTOMER"
};

const UserTypeValueMap = {
  "ANONYMOUS": UserType.ANONYMOUS,
  "BRAND": UserType.BRAND,
  "FACTORY": UserType.FACTORY,
  "DEFAULT": UserType.DEFAULT,
  "CUSTOMER": UserType.CUSTOMER
};

const UserTypeLocalizedMap = {
  UserType.ANONYMOUS: "游客",
  UserType.BRAND: "品牌端",
  UserType.FACTORY: "工厂端",
  UserType.DEFAULT: "系统默认",
  UserType.CUSTOMER: "客户"
};

enum UserStatus {
  ///在线
  ONLINE,

  ///离线
  OFFLINE
}
