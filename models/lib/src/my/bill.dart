import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'bill.g.dart';

enum BillType {
  ///提现
  WITHDRAWAL,

  ///付款
  PAYMENT,

  ///收款
  RECEIVABLES
}

// TODO: i18n处理
const BillTypeLocalizedMap = {
  BillType.WITHDRAWAL: "提现",
  BillType.PAYMENT: "付款",
  BillType.RECEIVABLES: "收款"
};

@JsonSerializable()
class BillModel extends ItemModel {
  ///账单类型
  String code;
  BillType type;
  double amount;
  double balance;
  String bankAccount;
  DateTime date;
  String remarks;
  OrderModel order;

  BillModel({this.code,
    this.type,
    this.amount,
    this.balance,
    this.bankAccount,
    this.remarks,
    this.order,
    this.date});

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);

  static Map<String, dynamic> toJson(BillModel model) =>
      _$BillModelToJson(model);
}

@JsonSerializable()
class AmountFlowModel extends ItemModel {
  ///公司
  CompanyModel company;

  ///账户
  String account;

  ///金额
  double amount;

  ///流水来源
  FlowSource flowSource;

  ///资金流水类型
  AmountFlowType amountFlowType;

  ///资金状态
  AmountStatus amountStatus;

  ///描述
  String description;

  ///备注
  String remark;

  ///平台备注
  String platformRemark;

  ///订单
  OrderModel order;

  AmountFlowModel({this.company,
    this.account,
    this.amount,
    this.flowSource,
    this.amountFlowType,
    this.amountStatus,
    this.description,
    this.remark,
    this.platformRemark,
    this.order});

  factory AmountFlowModel.fromJson(Map<String, dynamic> json) =>
      _$AmountFlowModelFromJson(json);

  static Map<String, dynamic> toJson(AmountFlowModel model) =>
      _$AmountFlowModelToJson(model);
}

///账户流水类型
enum FlowSource {
  ///提现
  CASH_OUT,

  ///打样单
  PROOFING,

  ///生产单定金
  PURCHASE_DEPOSIT,

  ///生产单尾款
  PURCHASE_BALANCE
}

///资金流水类型
enum AmountFlowType {
  ///流入
  INFLOW,

  ///流出
  OUTFLOW
}

///资金状态
enum AmountStatus {
  ///未结算
  AUDITING,

  ///已完成,
  COMPLETED,

  ///已取消
  CANCELED,

  ///拒绝
  REJECTED,
}
