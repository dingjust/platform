import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'brands_response.g.dart';

/// 工厂列表响应
@JsonSerializable()
class BrandsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<BrandModel> content;

  BrandsResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory BrandsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BrandsResponseFromJson(json);

  static Map<String, dynamic> toJson(BrandsResponse model) =>
      model == null ? null : _$BrandsResponseToJson(model);
}
