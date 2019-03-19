import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'sample_products_response.g.dart';

/// 商品列表响应
@JsonSerializable()
class SampleProductsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SampleProductModel> content;

  SampleProductsResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory SampleProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$SampleProductsResponseFromJson(json);

  static Map<String, dynamic> toJson(SampleProductsResponse model) =>
      _$SampleProductsResponseToJson(model);
}

