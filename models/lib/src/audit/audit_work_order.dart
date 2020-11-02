import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'audit_work_order.g.dart';

///审核工单
@JsonSerializable()
class AuditWorkOrderModel extends ItemModel {
  ///编码
  String code;

  ///类型
  String type;

  ///类型名称
  String typeLabel;

  ///原始code
  String originCode;

  ///审核信息
  String auditMsg;

  ///审核状态
  AuditState state;

  ///提交时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime submitTime;

  ///审核时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime auditTime;

  ///撤回时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime revokeTime;

  ///撤回用户
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel revokeUser;

  ///审核对象
  dynamic auditModel;

  ///提交用户
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel submitUser;

  ///所属公司
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel belongTo;

  AuditWorkOrderModel({
    this.code,
    this.type,
    this.typeLabel,
    this.originCode,
    this.auditMsg,
    this.state,
    this.submitTime,
    this.auditTime,
    this.revokeTime,
    this.revokeUser,
    this.auditModel,
    this.submitUser,
    this.belongTo,
  });

  factory AuditWorkOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AuditWorkOrderModelFromJson(json);

  static Map<String, dynamic> toJson(AuditWorkOrderModel model) =>
      model == null ? null : _$AuditWorkOrderModelToJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel model) =>
      model == null ? null : CompanyModel.toJson(model);
}

///审核状态
enum AuditState {
  ///无
  NONE,

  ///审核中
  AUDITING,

  ///审核通过
  PASSED,

  ///审核失败
  AUDITED_FAILED,

  ///撤回
  REVOKED
}

///审核状态
const AuditStateLocalizedMap = {
  AuditState.NONE: "无",
  AuditState.AUDITING: "审核中",
  AuditState.PASSED: "审核通过",
  AuditState.AUDITED_FAILED: "审核失败",
  AuditState.REVOKED: "撤回",
};
