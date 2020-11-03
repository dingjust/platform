import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'out_order_response.g.dart';

/// 外发订单列表响应
@JsonSerializable()
class OutOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SalesProductionOrderModel> content;

  OutOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory OutOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OutOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OutOrdersResponseToJson(this);
}
