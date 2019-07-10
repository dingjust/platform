import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'bank_card.g.dart';

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
    @JsonKey(
        fromJson: _dateTimefromMilliseconds,
        toJson: _dateTimetoMilliseconds)
  DateTime creationtime;

  BankCardModel({this.code,
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

const FlowSourceLocalizedMap = {
  FlowSource.CASH_OUT: '提现',
  FlowSource.PROOFING: '收款',
  FlowSource.PURCHASE_BALANCE: '收款',
  FlowSource.PURCHASE_DEPOSIT: '收款',
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

  ///已取消
  CANCELED,

  ///拒绝
  REJECTED,
}

const AmountStatusLocalizedMap = {
  AmountStatus.AUDITING: '审核中',
  AmountStatus.COMPLETED: '成功',
  AmountStatus.CANCELED: '已取消',
  AmountStatus.REJECTED: '失败'
};
