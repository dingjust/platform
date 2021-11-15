import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'payment_order.g.dart';

/// 付款单
@JsonSerializable()
class PaymentOrderModel extends ItemModel {
  /// 当前账期
  PayMoneyType moneyType;

  /// 付款金额
  double amount;

  ///付款类型
  PaymentType paymentType;

  ///支付凭证
  MediaModel payCertificate;

  ///备注
  String remarks;

  ///剩余支付金额
  double remainPaymentAmount;

  ///所属账务方案子项
  @JsonKey(toJson: _orderPayPlanItemToJson)
  OrderPayPlanItemModel orderPayPlanItem;

  PaymentOrderModel(
      {this.moneyType,
      this.amount,
      this.paymentType,
      this.payCertificate,
      this.remarks,
      this.remainPaymentAmount});

  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$PaymentOrderModelFromJson(json);

  static Map<String, dynamic> toJson(PaymentOrderModel model) =>
      model == null ? null : _$PaymentOrderModelToJson(model);

  static Map<String, dynamic> _orderPayPlanItemToJson(
          OrderPayPlanItemModel orderPayPlanItem) =>
      orderPayPlanItem == null
          ? null
          : OrderPayPlanItemModel.toJson(orderPayPlanItem);
}

/// 收款单
@JsonSerializable()
class ReceiptOrderModel extends ItemModel {
  /// 当前账期
  PayMoneyType moneyType;

  /// 付款金额
  double amount;

  ///付款类型
  PaymentType paymentType;

  ///支付凭证
  MediaModel payCertificate;

  ///备注
  String remarks;

  ///剩余支付金额
  double remainPaymentAmount;

  ///所属账务方案子项
  @JsonKey(toJson: _orderPayPlanItemToJson)
  OrderPayPlanItemModel orderPayPlanItem;

  ReceiptOrderModel(
      {this.moneyType,
      this.amount,
      this.paymentType,
      this.payCertificate,
      this.remarks,
      this.remainPaymentAmount});

  factory ReceiptOrderModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ReceiptOrderModelFromJson(json);

  static Map<String, dynamic> toJson(ReceiptOrderModel model) =>
      model == null ? null : _$ReceiptOrderModelToJson(model);

  static Map<String, dynamic> _orderPayPlanItemToJson(
          OrderPayPlanItemModel orderPayPlanItem) =>
      orderPayPlanItem == null
          ? null
          : OrderPayPlanItemModel.toJson(orderPayPlanItem);
}

/// 支付账号
@JsonSerializable()
class OrderPaymentAccountData extends ItemModel {
  /// 用户名
  String name;

  /// 服务提供方
  String serviceProvider;

  ///号码
  String no;

  ///类型
  OrderPaymentAccountType type;

  OrderPaymentAccountData({
    this.name,
    this.serviceProvider,
    this.no,
    this.type,
  });

  factory OrderPaymentAccountData.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderPaymentAccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderPaymentAccountDataToJson(this);
}

/// 支付订单
@JsonSerializable()
class CmtPayOrderData extends ItemModel {
  /// 单号
  String code;

  /// 来源单号
  String originCode;

  ///支付批次
  int batch;

  ///支付金额
  double payAmount;

  ///支付方式
  PaymentMethod payType;

  ///订单类型
  String orderType;

  ///备注
  String remark;

  ///外部订单号
  String outOrderNo;

  ///支付成功时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime paySuccessTime;

  ///支付状态
  CmtPaymentState state;

  ///支持信用卡支付
  bool supportCreditCard;

  ///归属公司
  @JsonKey(toJson: CompanyModel.toJson)
  CompanyModel belongTo;

  ///是否分账
  bool profitSharing;

  ///支付用户
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel payUser;

  ///内部回调已完成
  bool systemTriggerFinished;

  ///事务
  CmtPayTransactionData transactions;

  ///金额V2
  double totalAmount;

  int totalOrder;

  CmtPayOrderData(
      {this.code,
      this.originCode,
      this.batch,
      this.payAmount,
      this.payType,
      this.orderType,
      this.remark,
      this.outOrderNo,
      this.paySuccessTime,
      this.state,
      this.supportCreditCard,
      this.belongTo,
      this.profitSharing,
      this.payUser,
      this.systemTriggerFinished,
      this.transactions,
      this.totalAmount,
      this.totalOrder});

  factory CmtPayOrderData.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CmtPayOrderDataFromJson(json);

  Map<String, dynamic> toJson() => _$CmtPayOrderDataToJson(this);

  ///是否可以支付
  bool get canPay {
    return [CmtPaymentState.WAIT_TO_PAY, CmtPaymentState.PAYING]
        .contains(state);
  }
}

/// 支付事务
@JsonSerializable()
class CmtPayTransactionData extends ItemModel {
  /// 支付方式
  CmtPaymentState payType;

  /// 细分支付方式
  CmtPaymentState subPayType;

  ///支付用户
  @JsonKey(toJson: B2BCustomerModel.toJson)
  B2BCustomerModel payUser;

  ///支付签名
  String outOrderNo;

  ///已支付
  bool paid;

  ///支付成功时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime paySuccessTime;

  ///初次回掉时间
  @JsonKey(fromJson: dateTimefromMilliseconds)
  DateTime firstCallbackTime;

  ///重复支付
  bool repeatPayment;

  CmtPayTransactionData({
    this.payType,
    this.subPayType,
    this.payUser,
    this.outOrderNo,
    this.paid,
    this.paySuccessTime,
    this.firstCallbackTime,
    this.repeatPayment,
  });

  factory CmtPayTransactionData.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CmtPayTransactionDataFromJson(json);

  Map<String, dynamic> toJson() => _$CmtPayTransactionDataToJson(this);
}

///收款账号类型
enum OrderPaymentAccountType {
  ///微信钱包
  WECHAT,

  ///支付宝钱包
  ALIPAY,

  ///银行卡
  BANK,
}

///收款账号类型
const OrderPaymentAccountTypeLocalizedMap = {
  OrderPaymentAccountType.WECHAT: "微信钱包",
  OrderPaymentAccountType.ALIPAY: "支付宝钱包",
  OrderPaymentAccountType.BANK: "银行卡",
};

///支付方式
enum PaymentMethod {
  ///网银
  E_BANK,

  ///现金
  CASH,

  ///承兑
  ACCEPTANCE,

  ///支付宝
  ALIPAY,

  ///微信支付
  WECHAT_PAY,

  ///微信扫码支付
  WECHAT_PAY_NATIVE,

  ///微信APP支付
  WECHAT_PAY_APP,

  ///微信二维码支付
  WECHAT_PAY_QRCODE,

  ///微信内部支付
  WECHAT_PAY_MP
}

///支付方式
const PaymentMethodLocalizedMap = {
  PaymentMethod.E_BANK: "网银",
  PaymentMethod.CASH: "现金",
  PaymentMethod.ACCEPTANCE: "承兑",
  PaymentMethod.ALIPAY: "支付宝",
  PaymentMethod.WECHAT_PAY: "微信支付",
  PaymentMethod.WECHAT_PAY_NATIVE: "微信扫码支付",
  PaymentMethod.WECHAT_PAY_APP: "微信APP支付",
  PaymentMethod.WECHAT_PAY_QRCODE: "微信二维码支付",
  PaymentMethod.WECHAT_PAY_MP: "微信内部支付",
};

///支付状态
enum CmtPaymentState {
  ///待付款
  WAIT_TO_PAY,

  ///待付款(付款中,已创建付款单)
  PAYING,

  ///部分付款
  PAID_PART,

  ///已付款
  PAID,

  ///付款失败
  PAY_FAIL,

  ///退款中
  REFUNDING,

  ///已退款
  FUFUNDED,
}

///支付方式
const CmtPaymentStateLocalizedMap = {
  CmtPaymentState.WAIT_TO_PAY: "待付款",
  CmtPaymentState.PAYING: "待付款", //付款中
  CmtPaymentState.PAID_PART: "部分付款",
  CmtPaymentState.PAID: "已付款",
  CmtPaymentState.PAY_FAIL: "付款失败",
  CmtPaymentState.REFUNDING: "退款中",
  CmtPaymentState.FUFUNDED: "已退款",
};
