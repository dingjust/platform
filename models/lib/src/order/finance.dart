import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'finance.g.dart';

///账期支付方式
enum PayPlanType {
  ///一期尾款
  PHASEONE,

  ///二期尾款
  PHASETWO,

  ///三期尾款
  PHASETHREE,

  ///月结
  MONTHLY_SETTLEMENT,

  ///一月一结
  MONTHLY_SETTLEMENT_ONE,

  ///一月两结
  MONTHLY_SETTLEMENT_TWO,
}

///账期支付方式
const PayPlanTypeLocalizedMap = {
  PayPlanType.PHASEONE: "一期尾款",
  PayPlanType.PHASETWO: "二期尾款",
  PayPlanType.MONTHLY_SETTLEMENT: "月结",
  PayPlanType.PHASETHREE: "三期尾款",
  PayPlanType.MONTHLY_SETTLEMENT_ONE: "一月一结",
  PayPlanType.MONTHLY_SETTLEMENT_TWO: "一月两结"
};

///账期支付类型
enum PayMoneyType {
  ///定金
  DEPOSIT,

  ///一期款
  PHASEONE,

  ///二期款
  PHASETWO,

  ///三期款
  PHASETHREE,

  ///月结
  MONTHLY_SETTLEMENT,

  ///一月一结
  MONTHLY_SETTLEMENT_ONE,

  ///一月两结
  MONTHLY_SETTLEMENT_TWO
}

///账期支付类型
const PayMoneyTypeLocalizedMap = {
  PayMoneyType.DEPOSIT: "定金",
  PayMoneyType.PHASEONE: "一期款",
  PayMoneyType.PHASETWO: "二期款",
  PayMoneyType.PHASETHREE: "三期款",
  PayMoneyType.MONTHLY_SETTLEMENT: "月结",
  PayMoneyType.MONTHLY_SETTLEMENT_ONE: "一月一结",
  PayMoneyType.MONTHLY_SETTLEMENT_TWO: "一月两结",
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

///支付月类型
enum MonthType {
  ///本月
  CURRENT_MONTH,

  ///下月
  NEXT_MONTH
}

///支付类型
const MonthTypeLocalizedMap = {
  MonthType.CURRENT_MONTH: "本月",
  MonthType.NEXT_MONTH: "下月",
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

  AbstractPayPlanModel({
    this.name,
    this.isHaveDeposit,
    this.payPlanType,
    this.payPlanItems,
  });

  factory AbstractPayPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AbstractPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractPayPlanModel model) =>
      model == null ? null : _$AbstractPayPlanModelToJson(model);

  static List<Map<String, dynamic>> itemsToJson(
          List<AbstractPayPlanItemModel> items) =>
      items == null
          ? null
          : items.map((item) => AbstractPayPlanItemModel.toJson(item)).toList();
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

  ///支付状态
  PayStatus payStatus;

  String brandPayStatus;

  String factoryPayStatus;

  int payDayNum;

  int monthlyStartDayNum;

  int monthlyEndDayNum;

  bool isRange;

  bool isLast;

  MonthType monthType;

  AbstractPayPlanItemModel(
      {this.payPercent,
      this.triggerEvent,
      this.triggerDays,
      this.moneyType,
      this.triggerType,
      this.payStatus,
      this.sequence,
      this.brandPayStatus,
      this.factoryPayStatus,
      this.payDayNum,
      this.monthlyStartDayNum,
      this.monthlyEndDayNum,
      this.isRange,
      this.isLast,
      this.monthType});

  factory AbstractPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AbstractPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(AbstractPayPlanItemModel model) =>
      model == null ? null : _$AbstractPayPlanItemModelToJson(model);
}

/// 付款方案
@JsonSerializable()
class CompanyPayPlanModel extends AbstractPayPlanModel {
  /// 激活状态
  ArticleApprovalStatus approvalStatus;

  /// 公司
  @JsonKey(toJson: principalToJson)
  PrincipalModel belongTo;

  ///备注
  String remarks;

  ///预览
  String previewText;

  CompanyPayPlanModel({String name,
    bool isHaveDeposit,
    PayPlanType payPlanType,
    List<AbstractPayPlanItemModel> payPlanItems,
    this.approvalStatus,
    this.remarks,
    this.previewText})
      : super(
      name: name,
      isHaveDeposit: isHaveDeposit,
      payPlanType: payPlanType,
      payPlanItems: payPlanItems);

  factory CompanyPayPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CompanyPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyPayPlanModel model) =>
      model == null ? null : _$CompanyPayPlanModelToJson(model);

  static Map<String, dynamic> principalToJson(PrincipalModel belongTo) =>
      belongTo == null
          ? null
          : belongTo == null
              ? null
              : PrincipalModel.toJson(belongTo);
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
    String brandPayStatus,
    String factoryPayStatus,
    int payDayNum,
    int monthlyStartDayNum,
    int monthlyEndDayNum,
    bool isRange,
    bool isLast,
    PayStatus payStatus,
    MonthType monthType,
  }) : super(
      payPercent: payPercent,
      triggerEvent: triggerEvent,
      triggerDays: triggerDays,
      moneyType: moneyType,
      triggerType: triggerType,
      sequence: sequence,
      brandPayStatus: brandPayStatus,
      factoryPayStatus: factoryPayStatus,
      payDayNum: payDayNum,
      monthlyEndDayNum: monthlyEndDayNum,
      monthlyStartDayNum: monthlyStartDayNum,
      isRange: isRange,
      isLast: isLast,
      payStatus: payStatus,
      monthType: monthType);

  factory CompanyPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CompanyPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(CompanyPayPlanItemModel model) =>
      model == null ? null : _$CompanyPayPlanItemModelToJson(model);
}

/// 订单付款方案
@JsonSerializable()
class OrderPayPlanModel extends AbstractPayPlanModel {
  /// 所属订单
  AbstractOrderModel belongOrder;

  ///已付
  double paidAmount;

  OrderPayPlanModel({
    String name,
    bool isHaveDeposit,
    PayPlanType payPlanType,
    List<AbstractPayPlanItemModel> payPlanItems,
    this.paidAmount,
    this.belongOrder,
  }) : super(
            name: name,
            isHaveDeposit: isHaveDeposit,
            payPlanType: payPlanType,
            payPlanItems: payPlanItems);

  factory OrderPayPlanModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderPayPlanModelFromJson(json);

  static Map<String, dynamic> toJson(OrderPayPlanModel model) =>
      model == null ? null : _$OrderPayPlanModelToJson(model);
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
    String brandPayStatus,
    String factoryPayStatus,
    int payDayNum,
    int monthlyStartDayNum,
    int monthlyEndDayNum,
    bool isRange,
    PayStatus payStatus,
  }) : super(
      payPercent: payPercent,
      triggerEvent: triggerEvent,
      triggerDays: triggerDays,
      moneyType: moneyType,
      triggerType: triggerType,
      sequence: sequence,
      brandPayStatus: brandPayStatus,
      factoryPayStatus: factoryPayStatus,
      payDayNum: payDayNum,
      monthlyEndDayNum: monthlyEndDayNum,
      monthlyStartDayNum: monthlyStartDayNum,
      isRange: isRange,
      payStatus: payStatus);

  factory OrderPayPlanItemModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderPayPlanItemModelFromJson(json);

  static Map<String, dynamic> toJson(OrderPayPlanItemModel model) =>
      model == null ? null : _$OrderPayPlanItemModelToJson(model);

  static List<Map<String, dynamic>> _paymentOrdersToJson(
          List<PaymentOrderModel> paymentOrders) =>
      paymentOrders == null
          ? null
          : paymentOrders
          .map((order) => PaymentOrderModel.toJson(order))
          .toList();

  static List<Map<String, dynamic>> _receiptOrdersToJson(
          List<ReceiptOrderModel> receiptOrders) =>
      receiptOrders == null
          ? null
          : receiptOrders
          .map((order) => ReceiptOrderModel.toJson(order))
          .toList();
}
