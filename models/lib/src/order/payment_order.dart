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
