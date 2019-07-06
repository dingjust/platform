import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'amount_flow_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class AmountFlowResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<AmountFlowModel> content;

  AmountFlowResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory AmountFlowResponse.fromJson(Map<String, dynamic> json) =>
      _$AmountFlowResponseFromJson(json);

  static Map<String, dynamic> toJson(AmountFlowResponse model) =>
      _$AmountFlowResponseToJson(model);
}

