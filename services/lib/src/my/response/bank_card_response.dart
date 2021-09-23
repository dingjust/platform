import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'bank_card_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class BankCardResponse {
  final int code;
  final int resultCode;

  final List<BankCardModel> data;

  BankCardResponse(this.code, this.resultCode, this.data);

  factory BankCardResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BankCardResponseFromJson(json);

  static Map<String, dynamic> toJson(BankCardResponse model) =>
      model == null ? null : _$BankCardResponseToJson(model);
}
