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
      json == null ? null : _$AmountFlowModelFromJson(json);

  static Map<String, dynamic> toJson(AmountFlowModel model) =>
      model == null ? null : _$AmountFlowModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static int _dateTimetoMilliseconds(DateTime date) =>
      date == null ? null : date.millisecondsSinceEpoch;
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
  PURCHASE_BALANCE,

  ///销售订单
  SALES_ORDER,

  ///销售订单退款
  SALES_ORDER_REFUND
}

const FlowSourceLocalizedMap = {
  FlowSource.CASH_OUT: '提现',
  FlowSource.PROOFING: '打样单',
  FlowSource.PURCHASE_BALANCE: '生产单尾款',
  FlowSource.PURCHASE_DEPOSIT: '生产单定金',
  FlowSource.SALES_ORDER: '销售订单',
  FlowSource.SALES_ORDER_REFUND: '销售订单退款',
};

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

  ///已结算
  SETTLED,

  ///已退货
  REFUNDED,

  ///退货中
  IN_REFUND,

  ///进行中
  IN_PROGRESS,

  ///关闭
  CLOSED,

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
  AmountStatus.COMPLETED: '已完成',
  AmountStatus.SETTLED: '已结算',
  AmountStatus.REFUNDED: '已退货',
  AmountStatus.IN_REFUND: '退货中',
  AmountStatus.IN_PROGRESS: '进行中',
  AmountStatus.CANCELED: '已取消',
  AmountStatus.CLOSED: '关闭',
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

  ///银行卡Icon
  String iconUrl;

  ///开户网点
  String bankOutlet;

  ///日期
  ///  //注册时间
  @JsonKey(fromJson: _dateTimefromMilliseconds, toJson: _dateTimetoMilliseconds)
  DateTime creationtime;

  BankCardModel({this.company,
    this.bankCode,
    this.bankName,
    this.accountName,
    this.cardNumber,
    this.approvalStatus,
    this.creationtime,
    this.bankOutlet,
    this.iconUrl});

  factory BankCardModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BankCardModelFromJson(json);

  static Map<String, dynamic> toJson(BankCardModel model) =>
      model == null ? null : _$BankCardModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);

  static int _dateTimetoMilliseconds(DateTime date) =>
      date == null ? null : date.millisecondsSinceEpoch;
}

@JsonSerializable()
class BillModel extends ItemModel {
  int id;

  ///交易单号
  String code;

  ///付款方公司
  CompanyModel billTo;

  ///收款方公司
  CompanyModel billFrom;

  ///账户
  BankCardModel account;

  ///金额
  double amount;

  ///流水来源
  FlowSource flowSource;

  ///资金状态
  AmountStatus amountStatus;

  ///资金流水类型
  AmountFlowType amountFlowType;

  ///描述
  String description;

  ///备注
  String remark;

  ///付款方备注
  String billToRemarks;

  ///收款方备注
  String billFromRemarks;

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

  BillModel({this.id,
    this.code,
    this.billTo,
    this.billFrom,
    this.account,
    this.amount,
    this.flowSource,
    this.amountStatus,
    this.amountFlowType,
    this.description,
    this.remark,
    this.billToRemarks,
    this.billFromRemarks,
    this.platformRemark,
    this.creationtime,
    this.cashCompletionTime,
    this.orderCode});

  factory BillModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BillModelFromJson(json);

  static Map<String, dynamic> toJson(BillModel model) =>
      model == null ? null : _$BillModelToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      date == null ? date : DateTime.fromMillisecondsSinceEpoch(date);

  static int _dateTimetoMilliseconds(DateTime date) =>
      date == null ? null : date.millisecondsSinceEpoch;
}
