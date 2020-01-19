import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'subcontract_response.g.dart';

/// 合作商列表响应
@JsonSerializable()
class SubContractResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SubContractModel> content;

  SubContractResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory SubContractResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SubContractResponseFromJson(json);

  static Map<String, dynamic> toJson(SubContractResponse model) =>
      model == null ? null : _$SubContractResponseToJson(model);
}
