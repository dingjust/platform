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
  FACTORY
}
