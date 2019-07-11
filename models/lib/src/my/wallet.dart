import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'wallet.g.dart';

@JsonSerializable()
class AmountFlowModel extends ItemModel {
  ///交易单号
  String code;

  ///公司
  CompanyModel company;

  ///账户
  BankCardModel account;

  ///金额
  double amount;

  ///流水来源
  FlowSource flowSource;

  ///资金流水类型
  AmountFlowType amountFlowType;

  ///描述
  String description;

  ///备注
  String remark;

  ///平台备注
  String platformRemark;

  ///剩余总额
  double totalResidualAmount;

  ///日期
  ///  //注册时间
  @JsonKey(fromJson: _dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime creationtime;

  AmountFlowModel(
      {this.code,
      this.company,
      this.account,
      this.amount,
      this.flowSource,
      this.amountFlowType,
      this.description,
      this.remark,
      this.platformRemark,
      this.creationtime,
      this.totalResidualAmount});

  factory AmountFlowModel.fromJson(Map<String, dynamic> json) =>
      _$AmountFlowModelFromJson(json);

  static Map<String, dynamic> toJson(AmountFlowModel model) =>
      _$AmountFlowModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
  static int _dateTimetoMilliseconds(DateTime date) =>
      date.millisecondsSinceEpoch;
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

///资金流水
const AmountFlowTypeLocalizedMap = {
  ///流入
  AmountFlowType.INFLOW: '流入',

  ///流出
  AmountFlowType.OUTFLOW: '流出'
};

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

  ///审核中
  IN_REVIEW,

  ///已审核
  REVIEWED,
}

const AmountStatusLocalizedMap = {
  AmountStatus.AUDITING: '未结算',
  AmountStatus.COMPLETED: '已结算',
  AmountStatus.CANCELED: '已取消',
  AmountStatus.REJECTED: '提现拒绝',
  AmountStatus.IN_REVIEW: '审核中',
  AmountStatus.REVIEWED: '已审核',
};

@JsonSerializable()
class BankCardModel extends ItemModel {
  ///银行卡编号
  String bankCode;

  ///公司
  CompanyModel company;

  ///银行名字
  String bankName;

  ///账户名
  String accountName;

  /// 卡号
  String cardNumber;

  ArticleApprovalStatus approvalStatus;

  ///日期
  ///  //注册时间
  @JsonKey(fromJson: _dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime creationtime;

  BankCardModel({
    this.company,
    this.bankCode,
    this.bankName,
    this.accountName,
    this.cardNumber,
    this.approvalStatus,
    this.creationtime,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) =>
      _$BankCardModelFromJson(json);

  static Map<String, dynamic> toJson(BankCardModel model) =>
      _$BankCardModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
  static int _dateTimetoMilliseconds(DateTime date) =>
      date.millisecondsSinceEpoch;
}

@JsonSerializable()
class BillModel extends ItemModel {
  ///交易单号
  String code;

  ///公司
  CompanyModel company;

  ///账户
  BankCardModel account;

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

  ///订单编号
  String orderCode;

  ///日期
  ///  //注册时间
  @JsonKey(fromJson: _dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime creationtime;

  @JsonKey(fromJson: _dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime cashCompletionTime;

  BillModel(
      {this.code,
      this.company,
      this.account,
      this.amount,
      this.flowSource,
      this.amountFlowType,
      this.amountStatus,
      this.description,
      this.remark,
      this.platformRemark,
      this.creationtime,
      this.cashCompletionTime,
      this.orderCode});

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      _$BillModelFromJson(json);

  static Map<String, dynamic> toJson(BillModel model) =>
      _$BillModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
  static int _dateTimetoMilliseconds(DateTime date) =>
      date.millisecondsSinceEpoch;
}

const FlowSourceLocalizedMap = {
  FlowSource.CASH_OUT: '提现',
  FlowSource.PROOFING: '收款',
  FlowSource.PURCHASE_BALANCE: '收款',
  FlowSource.PURCHASE_DEPOSIT: '收款',
};
