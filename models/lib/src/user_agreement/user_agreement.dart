import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_agreement.g.dart';

@JsonSerializable()
class UserAgreementModel extends ContractModel {
  ///合同类型
  AgreementTemplateType? type;

  bool? deleted;

  ///甲方
  CompanyModel? partyA;

  ///乙方
  CompanyModel? partyB;

  ///甲方签署时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? partyASignTime;

  ///乙方签署时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? partyBSignTime;

  ///合同完成时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime? completeSignTime;

  ///模板编号
  String? originalTmplCode;

  ///线下合作商
  bool? offlinePartner;

  bool? isOffline;

  UserAgreementModel({
    String? title,
    String? contractNumber,
    String? partner,
    DateTime? createTime,
    ContractStatus? state,
    bool? available,
    String? code,
    String? content,
    bool? isCreator,
    bool? isSigned,
    this.type,
    this.deleted,
    this.partyA,
    this.partyB,
    this.partyASignTime,
    this.partyBSignTime,
    this.completeSignTime,
    this.originalTmplCode,
    this.offlinePartner,
    this.isOffline,
  }) : super(
          title: title,
          contractNumber: contractNumber,
          partner: partner,
          createTime: createTime,
          state: state,
          available: available,
          content: content,
          isCreator: isCreator,
          isSigned: isSigned,
          code: code,
        );

  factory UserAgreementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAgreementModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAgreementModelToJson(this);
}
