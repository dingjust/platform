import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'bank_card.g.dart';

@JsonSerializable()
class BankCardModel extends ItemModel {
  ///户名
  String accountName;

  ///卡号
  String cardNumber;

  ///银行名
  String bankName;

  ///日期
  @JsonKey(name: "creationtime", fromJson: dateTimefromMilliseconds)
  DateTime creationtime;

  BankCardModel({
    this.accountName,
    this.cardNumber,
    this.bankName,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BankCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankCardModelToJson(this);
}
