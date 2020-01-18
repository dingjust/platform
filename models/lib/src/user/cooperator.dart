import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'cooperator.g.dart';

enum CooperatorType {
  ///线上供应商
  ONLINE,

  ///线下供应商
  OFFLINE
}

// TODO: i18n处理
const CooperatorTypeLocalizedMap = {
  CooperatorType.ONLINE: "线上合作商",
  CooperatorType.OFFLINE: "自定义",
};

enum CooperatorCategory {
  ///供应商
  SUPPLIER,

  ///CUSTOMER
  CUSTOMER
}

/// 合作商
@JsonSerializable()
class CooperatorModel extends ItemModel {
  int id;

  ///合作商名称
  String name;

  ///联系人
  String contactPerson;

  ///联系方式
  String contactPhone;

  ///所属公司
  @JsonKey(toJson: companyToJson)
  CompanyModel belongTo;

  ///合作公司
  @JsonKey(toJson: companyToJson)
  CompanyModel partner;

  ///类型
  CooperatorType type;

  ///类别
  CooperatorCategory category;

  ///详细身份
  String detailedIdentity;

  ///开户行
  String bankOfDeposit;

  ///银行账号
  String bankAccount;

  ///税号
  String taxNumber;

  ///账务方案
  @JsonKey(toJson: companyPayPlanToJson)
  CompanyPayPlanModel payPlan;

  ///备注
  String remarks;

  CooperatorModel({
    this.id,
    this.name,
    this.contactPerson,
    this.contactPhone,
    this.belongTo,
    this.partner,
    this.type,
    this.category,
    this.detailedIdentity,
    this.bankOfDeposit,
    this.bankAccount,
    this.taxNumber,
    this.payPlan,
    this.remarks,
  });

  factory CooperatorModel.fromJson(Map<String, dynamic> json) =>
      _$CooperatorModelFromJson(json);

  static Map<String, dynamic> toJson(CooperatorModel model) =>
      _$CooperatorModelToJson(model);

  static Map<String, dynamic> companyToJson(CompanyModel belongTo) =>
      belongTo == null ? null : CompanyModel.toJson(belongTo);

  static Map<String, dynamic> companyPayPlanToJson(
      CompanyPayPlanModel payPlan) =>
      payPlan == null ? null : CompanyPayPlanModel.toJson(payPlan);

  String getName() {
    if (type == CooperatorType.ONLINE) {
      return partner.name ?? '';
    } else {
      return name ?? '';
    }
  }
}
