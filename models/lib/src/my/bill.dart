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
  BillType type;
  double amount;
  double balance;
  PurchaseOrderModel order;
  String bankAccount;
  DateTime date;

  BillModel(
      {this.type,
      this.amount,
      this.balance,
      this.order,
      this.bankAccount,
      this.date});

  factory BillModel.fromJson(Map<String, dynamic> json) => _$BillModelFromJson(json);

  static Map<String, dynamic> toJson(BillModel model) => _$BillModelToJson(model);
}
