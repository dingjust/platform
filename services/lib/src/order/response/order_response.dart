import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'order_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class RequirementOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<RequirementOrderModel> content;

  RequirementOrdersResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory RequirementOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$RequirementOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrdersResponse model) =>
      _$RequirementOrdersResponseToJson(model);
}

/// 报价订单列表响应
@JsonSerializable()
class QuoteOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<QuoteModel> content;

  QuoteOrdersResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory QuoteOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$QuoteOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(QuoteOrdersResponse model) =>
      _$QuoteOrdersResponseToJson(model);
}