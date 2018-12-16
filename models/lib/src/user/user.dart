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
