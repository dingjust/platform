import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'user_agreement.g.dart';

@JsonSerializable()
class UserAgreementModel extends ItemModel {
  ///编号
  String code;

  ///标题
  String title;

  String content;

  ///合同类型
  AgreementTemplateType type;

  bool deleted;

  ///甲方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyA;

  ///乙方
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel partyB;

  ///甲方签署时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime partyASignTime;

  ///乙方签署时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime partyBSignTime;

  ///合同完成时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime completeSignTime;

  ///模板编号
  String originalTmplCode;

  ///合同签署状态
  AgreementState state;

  ///线下合作商
  bool offlinePartner;

  bool available;

  bool isCreator;

  bool isOffline;

  bool isSigned;

  UserAgreementModel({
    this.code,
    this.title,
    this.content,
    this.type,
    this.deleted,
    this.partyA,
    this.partyB,
    this.partyASignTime,
    this.partyBSignTime,
    this.completeSignTime,
    this.originalTmplCode,
    this.state,
    this.offlinePartner,
    this.available,
    this.isCreator,
    this.isOffline,
    this.isSigned,
  });

  factory UserAgreementModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$UserAgreementModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAgreementModelToJson(this);

  static DateTime dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);
}

///用户合同状态
enum AgreementState {
  ///初始状态
  INITIATE,

  ///签署中
  SIGN,

  ///甲方签署
  PARTY_A_SIGN,

  ///乙方签署
  PARTY_B_SIGN,

  ///完成
  COMPLETE,

  ///作废
  INVALID,

  ///查询-待我签署
  WAIT_ME_SIGN,

  ///查询-待对方签署
  WAIT_PARTNER_SIGN
}

///订单取消状态
const AgreementStateLocalizedMap = {
  AgreementState.INITIATE: "初始状态",
  AgreementState.SIGN: "签署中",
  AgreementState.PARTY_A_SIGN: "甲方签署",
  AgreementState.PARTY_B_SIGN: "乙方签署",
  AgreementState.COMPLETE: "完成",
  AgreementState.INVALID: "作废",
  AgreementState.WAIT_ME_SIGN: "查询-待我签署",
  AgreementState.WAIT_PARTNER_SIGN: "查询-待对方签署",
};
