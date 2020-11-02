import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'sale_production_response.g.dart';

/// 外接订单列表响应
@JsonSerializable()
class ExternalSaleOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SalesProductionOrderModel> content;

  ExternalSaleOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ExternalSaleOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ExternalSaleOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalSaleOrdersResponseToJson(this);
}
