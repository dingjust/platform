import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'company_response.g.dart';

/// 合作商列表响应
@JsonSerializable()
class CompanyResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<CompanyModel> content;

  CompanyResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CompanyResponseFromJson(json);

  static Map<String, dynamic> toJson(CompanyResponse model) =>
      model == null ? null : _$CompanyResponseToJson(model);
}
