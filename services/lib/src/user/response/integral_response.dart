import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'integral_response.g.dart';

/// 用户积分信息
@JsonSerializable()
class UserIntegralInfo {
  final int availablePoints;
  final int withholdPoints;
  final int recommendUser;

  UserIntegralInfo(
      this.availablePoints, this.withholdPoints, this.recommendUser);

  factory UserIntegralInfo.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$UserIntegralInfoFromJson(json);

  static Map<String, dynamic> toJson(UserIntegralInfo model) =>
      model == null ? null : _$UserIntegralInfoToJson(model);
}

/// 用户积分记录响应
@JsonSerializable()
class IntegralHistoryResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<IntegralHistoryModel> content;

  IntegralHistoryResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory IntegralHistoryResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$IntegralHistoryResponseFromJson(json);

  static Map<String, dynamic> toJson(IntegralHistoryResponse model) =>
      model == null ? null : _$IntegralHistoryResponseToJson(model);
}

/// 用户积分兑换记录响应
@JsonSerializable()
class IntegralExchangeHistoryResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<IntegralExchangeHistoryModel> content;

  IntegralExchangeHistoryResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory IntegralExchangeHistoryResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$IntegralExchangeHistoryResponseFromJson(json);

  static Map<String, dynamic> toJson(IntegralExchangeHistoryResponse model) =>
      model == null ? null : _$IntegralExchangeHistoryResponseToJson(model);
}

/// 积分兑换规则
@JsonSerializable()
class IntegralExchangeRule {
  final int id;
  final int points;
  final double amount;

  IntegralExchangeRule(this.id, this.points, this.amount);

  factory IntegralExchangeRule.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$IntegralExchangeRuleFromJson(json);

  static Map<String, dynamic> toJson(IntegralExchangeRule model) =>
      model == null ? null : _$IntegralExchangeRuleToJson(model);
}
