import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';

part 'principal.g.dart';
// import 'package:models/models.dart';

@JsonSerializable()
class PrincipalModel {
  int? id;
  MediaModel? profilePicture;
  String? uid;
  String? name;
  String? phone;
  String? contactPhone;
  String? contactPerson;
  ArticleApprovalStatus? approvalStatus;
  AddressModel? contactAddress;

  ///支付方案
  List<CompanyPayPlanModel>? payPlans;

  PrincipalModel({
    this.id,
    this.profilePicture,
    @required this.uid,
    this.name,
    this.phone,
    this.approvalStatus,
    this.contactAddress,
    this.contactPerson,
    this.contactPhone,
  });

  factory PrincipalModel.fromJson(Map<String, dynamic> json) =>
      _$PrincipalModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrincipalModelToJson(this);
}

/// Principal Group
@JsonSerializable()
class PrincipalGroupModel extends PrincipalModel {
  List<PrincipalModel>? members;

  PrincipalGroupModel({
    MediaModel? profilePicture,
    String? uid,
    String? name,
    ArticleApprovalStatus? approvalStatus,
    AddressModel? contactAddress,
    String? contactPhone,
    String? contactPerson,
    this.members,
  }) : super(
            profilePicture: profilePicture,
            uid: uid,
            name: name,
            approvalStatus: approvalStatus,
            contactAddress: contactAddress,
            contactPhone: contactPhone,
            contactPerson: contactPerson);

  factory PrincipalGroupModel.fromJson(Map<String, dynamic> json) =>
      _$PrincipalGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrincipalGroupModelToJson(this);
}
