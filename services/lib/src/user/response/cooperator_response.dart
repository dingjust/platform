import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'cooperator_response.g.dart';

/// 合作商列表响应
@JsonSerializable()
class CooperatorResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<CooperatorModel> content;

  CooperatorResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory CooperatorResponse.fromJson(Map<String, dynamic> json) =>
      _$CooperatorResponseFromJson(json);

  static Map<String, dynamic> toJson(CooperatorResponse model) =>
      _$CooperatorResponseToJson(model);
}
