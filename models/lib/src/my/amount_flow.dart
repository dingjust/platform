import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'amount_flow.g.dart';

@JsonSerializable()
class AmountFlowModel extends ItemModel {
  ///交易单号
  String code;

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

  ///日期
  DateTime creationtime;

  AmountFlowModel({this.code,
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
