import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'delivery_order_response.g.dart';

/// 出货单列表响应
@JsonSerializable()
class DeliveryOrderResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<FastShippingSheetModel> content;

  DeliveryOrderResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory DeliveryOrderResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$DeliveryOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryOrderResponseToJson(this);
}

/// 对账单列表响应
@JsonSerializable()
class ReconciliationOrderResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<FastReconciliationSheetModel> content;

  ReconciliationOrderResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ReconciliationOrderResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ReconciliationOrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReconciliationOrderResponseToJson(this);
}
