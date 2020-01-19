import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'apparel_product_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class ApparelProductResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ApparelProductModel> content;

  ApparelProductResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ApparelProductResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ApparelProductResponseFromJson(json);

  static Map<String, dynamic> toJson(ApparelProductResponse model) =>
      model == null ? null : _$ApparelProductResponseToJson(model);
}
