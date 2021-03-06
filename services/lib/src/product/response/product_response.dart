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

/// 面辅料列表响应
@JsonSerializable()
class MaterielProductsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<MaterielProductModel> content;

  MaterielProductsResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory MaterielProductsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$MaterielProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MaterielProductsResponseToJson(this);
}

/// 款式列表响应
@JsonSerializable()
class SampleProductsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SampleProductModel> content;

  SampleProductsResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory SampleProductsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SampleProductsResponseFromJson(json);

  static Map<String, dynamic> toJson(SampleProductsResponse model) =>
      model == null ? null : _$SampleProductsResponseToJson(model);
}
