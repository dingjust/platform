import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'product_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class ProductsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ApparelProductModel> content;

  ProductsResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProductsResponseFromJson(json);

  static Map<String, dynamic> toJson(ProductsResponse model) =>
      model == null ? null : _$ProductsResponseToJson(model);
}
