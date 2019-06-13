import 'package:json_annotation/json_annotation.dart';

part 'bank_response.g.dart';

/// 银行卡查询响应
@JsonSerializable()
class BankResponse {
  String cardType;

  String bank;

  String key;

  String bankName;

  bool validated;

  String stat;

  BankResponse(
      {this.cardType,
      this.bank,
      this.key,
      this.bankName,
      this.validated,
      this.stat});

  factory BankResponse.fromJson(Map<String, dynamic> json) =>
      _$BankResponseFromJson(json);

  static Map<String, dynamic> toJson(BankResponse model) =>
      _$BankResponseToJson(model);
}
