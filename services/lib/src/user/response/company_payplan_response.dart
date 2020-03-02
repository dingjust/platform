import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'company_payplan_response.g.dart';

/// 账务列表响应
@JsonSerializable()
class CompanyPayPlanResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<CompanyPayPlanModel> content;

  CompanyPayPlanResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory CompanyPayPlanResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CompanyPayPlanResponseFromJson(json);

  static Map<String, dynamic> toJson(CompanyPayPlanResponse model) =>
      model == null ? null : _$CompanyPayPlanResponseToJson(model);
}
