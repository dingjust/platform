import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'finance.g.dart';

///账期支付方式
enum PayPlanType {
  ///一期尾款
  PHASEONE,

  ///二期尾款
  PHASETWO,

  ///月结
  MONTHLY_SETTLEMENT
}

///账期支付方式
const PayPlanTypeLocalizedMap = {
  PayPlanType.PHASEONE: "一期尾款",
  PayPlanType.PHASETWO: "二期尾款",
  PayPlanType.MONTHLY_SETTLEMENT: "月结",
};

///账期支付类型
enum PayMoneyType {
  ///定金
  DEPOSIT,

  ///一期款
  PHASEONE,

  ///二期款
  PHASETWO,

  ///月结
  MONTHLY_SETTLEMENT
}

///账期支付类型
const PayMoneyTypeLocalizedMap = {
  PayMoneyType.DEPOSIT: "定金",
  PayMoneyType.PHASEONE: "一期款",
  PayMoneyType.PHASETWO: "二期款",
  PayMoneyType.MONTHLY_SETTLEMENT: "月结",
};

///触发事件
enum TriggerEvent {
  ///确认订单
  ORDER_CONFIRMED,

  ///签署合同
  CONTRACT_SIGNED,

  ///确认收货
  DELIVERY_CONFIRMED,

  ///确认对账
  RECONCILIATION_CONFIRMED,

  ///收到发票
  INVOICE_RECEIVED
}

///账期支付类型
const TriggerEventLocalizedMap = {
  TriggerEvent.ORDER_CONFIRMED: "确认订单",
  TriggerEvent.CONTRACT_SIGNED: "签署合同",
  TriggerEvent.DELIVERY_CONFIRMED: "确认收货",
  TriggerEvent.RECONCILIATION_CONFIRMED: "确认对账",
  TriggerEvent.INVOICE_RECEIVED: "收到发票",
};

///触发方式
enum TriggerType {
  ///以内
  INSIDE,

  ///以外
  OUTSIDE
}

///触发方式
const TriggerTypeLocalizedMap = {
  TriggerType.INSIDE: "以内",
  TriggerType.OUTSIDE: "以外",
};

///支付状态
enum PayStatus {
  ///已付
  PAID,

  ///未付
  UNPAID,

  ///欠款
  ARREARS
}

///支付状态
const PayStatusLocalizedMap = {
  PayStatus.PAID: "已付",
  PayStatus.UNPAID: "未付",
  PayStatus.ARREARS: "欠款",
};

///支付类型
enum PaymentType {
  ///部分付款
  PARTPAID,

  ///全部付款
  ALLPAID
}

///支付类型
const PaymentTypeLocalizedMap = {
  PaymentType.PARTPAID: "部分付款",
  PaymentType.ALLPAID: "全部付款",
};

/// 付款方案抽象
@JsonSerializable()
class AbstractPayPlanModel extends ItemModel {
  /// 名称
  String name;

  /// 是否有定金
  bool isHaveDeposit;

  ///尾款期数
  PayPlanType payPlanType;

  ///方案子项
  @JsonKey(toJson: itemsToJson)
  List<AbstractPayPlanItemModel> payPlanItems;

  AbstractPayPlanModel(
      {this.name, this.isHaveDeposit, this.payPlanType, this.payPlanItems});

  factory AbstractPayPlanModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractPayPlanModel model) =>
      _$AbstractPayPlanModelToJson(model);

  static List<Map<String, dynamic>> itemsToJson(
          List<AbstractPayPlanItemModel> items) =>
      items.map((item) => AbstractPayPlanItemModel.toJson(item)).toList();
}

/// 付款方案子项抽象
@JsonSerializable()
class AbstractPayPlanItemModel extends ItemModel {
  /// 支付比例
  double payPercent;

  /// 触发事件
  TriggerEvent triggerEvent;

  /// 触发时长
  int triggerDays;

  ///支付类型
  PayMoneyType moneyType;

  ///触发方式
  TriggerType triggerType;

  ///序列号
  int sequence;

  AbstractPayPlanItemModel(
      {this.payPercent,
      this.triggerEvent,
      this.triggerDays,
      this.moneyType,
      this.triggerType,
      this.sequence});

  factory AbstractPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      _$AbstractPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractPayPlanItemModel model) =>
      _$AbstractPayPlanItemModelToJson(model);
}

/// 付款方案
@JsonSerializable()
class CompanyPayPlanModel extends AbstractPayPlanModel {
  /// 激活状态
  ArticleApprovalStatus approvalStatus;

  /// 公司
  @JsonKey(toJson: principalToJson)
  PrincipalModel belongTo;

  CompanyPayPlanModel({
    String name,
    bool isHaveDeposit,
    PayPlanType payPlanType,
    List<AbstractPayPlanItemModel> payPlanItems,
    this.approvalStatus,
  }) : super(
            name: name,
            isHaveDeposit: isHaveDeposit,
            payPlanType: payPlanType,
            payPlanItems: payPlanItems);

  factory CompanyPayPlanModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyPayPlanModel model) =>
      _$CompanyPayPlanModelToJson(model);

  static Map<String, dynamic> principalToJson(PrincipalModel belongTo) =>
      PrincipalModel.toJson(belongTo);
}

/// 付款方案子项
@JsonSerializable()
class CompanyPayPlanItemModel extends AbstractPayPlanItemModel {
  CompanyPayPlanItemModel({
    double payPercent,
    TriggerEvent triggerEvent,
    int triggerDays,
    PayMoneyType moneyType,
    TriggerType triggerType,
    int sequence,
  }) : super(
            payPercent: payPercent,
            triggerEvent: triggerEvent,
            triggerDays: triggerDays,
            moneyType: moneyType,
            triggerType: triggerType,
            sequence: sequence);

  factory CompanyPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyPayPlanItemModel model) =>
      _$CompanyPayPlanItemModelToJson(model);
}

/// 订单付款方案
@JsonSerializable()
class OrderPayPlanModel extends AbstractPayPlanModel {
  /// 所属订单
  AbstractOrderModel belongOrder;

  OrderPayPlanModel({
    String name,
    bool isHaveDeposit,
    PayPlanType payPlanType,
    List<AbstractPayPlanItemModel> payPlanItems,
    this.belongOrder,
  }) : super(
            name: name,
            isHaveDeposit: isHaveDeposit,
            payPlanType: payPlanType,
            payPlanItems: payPlanItems);

  factory OrderPayPlanModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(OrderPayPlanModel model) =>
      _$OrderPayPlanModelToJson(model);
}

/// 订单付款方案子项
@JsonSerializable()
class OrderPayPlanItemModel extends AbstractPayPlanItemModel {
  ///付款单
  @JsonKey(toJson: _paymentOrdersToJson)
  List<PaymentOrderModel> paymentOrders;

  ///收款单
  @JsonKey(toJson: _receiptOrdersToJson)
  List<ReceiptOrderModel> receiptOrders;

  OrderPayPlanItemModel({
    double payPercent,
    TriggerEvent triggerEvent,
    int triggerDays,
    PayMoneyType moneyType,
    TriggerType triggerType,
    int sequence,
  }) : super(
            payPercent: payPercent,
            triggerEvent: triggerEvent,
            triggerDays: triggerDays,
            moneyType: moneyType,
            triggerType: triggerType,
            sequence: sequence);

  factory OrderPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(OrderPayPlanItemModel model) =>
      _$OrderPayPlanItemModelToJson(model);

  static List<Map<String, dynamic>> _paymentOrdersToJson(
          List<PaymentOrderModel> paymentOrders) =>
      paymentOrders.map((order) => PaymentOrderModel.toJson(order)).toList();

  static List<Map<String, dynamic>> _receiptOrdersToJson(
          List<ReceiptOrderModel> receiptOrders) =>
      receiptOrders.map((order) => ReceiptOrderModel.toJson(order)).toList();
}
