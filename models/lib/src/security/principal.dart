import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'principal.g.dart';

@JsonSerializable()
class PrincipalModel extends ItemModel {
  String profilePicture;
  String uid;
  String name;

  PrincipalModel({this.profilePicture, @required this.uid, this.name});

  factory PrincipalModel.fromJson(Map<String, dynamic> json) => _$PrincipalModelFromJson(json);

  static Map<String, dynamic> toJson(PrincipalModel model) => _$PrincipalModelToJson(model);
}

/// Principal Group
@JsonSerializable()
class PrincipalGroupModel extends PrincipalModel {
  PrincipalModel members;

  PrincipalGroupModel({
    String profilePicture,
    String uid,
    String name,
    this.members,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
        );

  factory PrincipalGroupModel.fromJson(Map<String, dynamic> json) => _$PrincipalGroupModelFromJson(json);

  static Map<String, dynamic> toJson(PrincipalGroupModel model) => _$PrincipalGroupModelToJson(model);
}
