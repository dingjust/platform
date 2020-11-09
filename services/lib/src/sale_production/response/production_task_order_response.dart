import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'production_task_order_response.g.dart';

/// 生产工单列表响应
@JsonSerializable()
class ProductionTaskOrderResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ProductionTaskOrderModel> content;

  ProductionTaskOrderResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ProductionTaskOrderResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductionTaskOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductionTaskOrderResponseToJson(this);
}
