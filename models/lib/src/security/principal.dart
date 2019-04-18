import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'principal.g.dart';

@JsonSerializable()
class PrincipalModel extends ItemModel {
  @JsonKey(toJson: mediaToJson)
  MediaModel profilePicture;
  String uid;
  String name;
  String phone;
  ArticleApprovalStatus approvalStatus;
  @JsonKey(toJson: addressToJson)
  AddressModel contactAddress;


  PrincipalModel({this.profilePicture, @required this.uid, this.name, this.phone,this.approvalStatus,this.contactAddress,});

  factory PrincipalModel.fromJson(Map<String, dynamic> json) => _$PrincipalModelFromJson(json);

  static Map<String, dynamic> toJson(PrincipalModel model) => _$PrincipalModelToJson(model);

  static Map<String, dynamic> mediaToJson(MediaModel model) => MediaModel.toJson(model);
  static Map<String, dynamic> addressToJson(AddressModel model) => AddressModel.toJson(model);
}

/// Principal Group
@JsonSerializable()
class PrincipalGroupModel extends PrincipalModel {
  List<PrincipalModel> members;

  PrincipalGroupModel({
    MediaModel profilePicture,
    String uid,
    String name,
    ArticleApprovalStatus approvalStatus,
    AddressModel contactAddress,
    this.members,
  }) : super(
          profilePicture: profilePicture,
          uid: uid,
          name: name,
          approvalStatus: approvalStatus,
          contactAddress: contactAddress,
        );

  factory PrincipalGroupModel.fromJson(Map<String, dynamic> json) => _$PrincipalGroupModelFromJson(json);

  static Map<String, dynamic> toJson(PrincipalGroupModel model) => _$PrincipalGroupModelToJson(model);
}
