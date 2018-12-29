import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'invoice.g.dart';

/// 发票抬头
@JsonSerializable()
class InvoiceTitleModel extends ItemModel {
  /// 公司名称
  String company;

  /// 税号
  String taxNumber;

  /// 公司地址
  String address;

  /// 公司电话
  String phone;

  /// 开户银行
  String bankOfDeposit;

  /// 银行账户
  String bankAccount;

  /// 是否默认抬头
  bool defaultTitle;

  /// 所有人
  PrincipalModel owner;

  InvoiceTitleModel({
    this.company,
    this.taxNumber,
    this.address,
    this.phone,
    this.bankOfDeposit,
    this.bankAccount,
    this.defaultTitle = false,
    this.owner,
  });

  factory InvoiceTitleModel.fromJson(Map<String, dynamic> json) => _$InvoiceTitleModelFromJson(json);

  static Map<String, dynamic> toJson(InvoiceTitleModel model) => _$InvoiceTitleModelToJson(model);
}

/// 开票信息
@JsonSerializable()
class TaxInvoiceModel extends ItemModel {
  /// 购方
  String buyer;

  /// 销方
  String seller;

  /// 开票类型
  InvoiceType type;

  /// 开票类别
  InvoiceCategory category;

  /// 发票类型
  InvoiceRecipientType recipientType;

  /// 抬头
  String recipient;

  /// 开票状态
  InvoiceStatus status;

  /// 发票代码
  String serialCode;

  /// 发票金额
  double amount;

  /// 开票日期
  DateTime billingDate;

  TaxInvoiceModel({
    this.buyer,
    this.seller,
    this.type,
    this.category,
    this.recipientType,
    this.recipient,
    this.status,
    this.serialCode,
    this.amount,
    this.billingDate,
  });

  factory TaxInvoiceModel.fromJson(Map<String, dynamic> json) => _$TaxInvoiceModelFromJson(json);

  static Map<String, dynamic> toJson(TaxInvoiceModel model) => _$TaxInvoiceModelToJson(model);
}

/// 开票类别
enum InvoiceCategory {
  /// 时装
  FASHION,

  /// 电子产品
  ELECTRONICS,

  /// 食品
  FOOD,

  /// 通用
  GENERAL
}

/// 开票接收人类型
enum InvoiceRecipientType {
  /// 个人
  INDIVIDUAL,

  /// 企业
  UNIT
}

/// 开票类型
enum InvoiceType {
  /// 电子发票
  ELECTRONIC,

  /// 纸质发票
  PAPER
}

/// 开票状态
enum InvoiceStatus {
  /// 已请求开票
  REQUESTED,

  /// 已开票
  ISSUED
}
