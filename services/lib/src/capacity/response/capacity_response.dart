import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'capacity_response.g.dart';

/// 产能列表响应
@JsonSerializable()
class FactoryCapacityResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<FactoryCapacityModel> content;

  FactoryCapacityResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory FactoryCapacityResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FactoryCapacityResponseFromJson(json);

  static Map<String, dynamic> toJson(FactoryCapacityResponse model) =>
      model == null ? null : _$FactoryCapacityResponseToJson(model);
}
