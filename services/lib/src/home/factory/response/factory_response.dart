import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'factory_response.g.dart';

/// 工厂列表响应
@JsonSerializable()
class FactoriesResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<FactoryModel> content;

  FactoriesResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory FactoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$FactoriesResponseFromJson(json);

  static Map<String, dynamic> toJson(FactoriesResponse model) =>
      _$FactoriesResponseToJson(model);
}
