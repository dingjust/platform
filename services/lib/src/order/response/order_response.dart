import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'order_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class RequirementOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<RequirementOrderModel> content;

  RequirementOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory RequirementOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$RequirementOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(RequirementOrdersResponse model) =>
      model == null ? null : _$RequirementOrdersResponseToJson(model);
}

/// 报价订单列表响应
@JsonSerializable()
class QuoteOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<QuoteModel> content;

  QuoteOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory QuoteOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$QuoteOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(QuoteOrdersResponse model) =>
      model == null ? null : _$QuoteOrdersResponseToJson(model);
}

/// 采购订单列表响应
@JsonSerializable()
class PurchaseOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<PurchaseOrderModel> content;

  PurchaseOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory PurchaseOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$PurchaseOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(PurchaseOrdersResponse model) =>
      model == null ? null : _$PurchaseOrdersResponseToJson(model);
}

/// 打样订单列表响应
@JsonSerializable()
class ProofingOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ProofingModel> content;

  ProofingOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ProofingOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProofingOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(ProofingOrdersResponse model) =>
      model == null ? null : _$ProofingOrdersResponseToJson(model);
}

/// 销售订单列表响应
@JsonSerializable()
class SalesOrdersResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SalesOrderModel> content;

  SalesOrdersResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory SalesOrdersResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$SalesOrdersResponseFromJson(json);

  static Map<String, dynamic> toJson(SalesOrdersResponse model) =>
      model == null ? null : _$SalesOrdersResponseToJson(model);
}

/// 节点方案列表响应
@JsonSerializable()
class OrderProgressPlanResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<OrderProgressPlanModel> content;

  OrderProgressPlanResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory OrderProgressPlanResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$OrderProgressPlanResponseFromJson(json);

  static Map<String, dynamic> toJson(OrderProgressPlanResponse model) =>
      model == null ? null : _$OrderProgressPlanResponseToJson(model);
}

/// 节点列表响应
@JsonSerializable()
class ProgressPhaseResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ProgressPhaseModel> content;

  ProgressPhaseResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory ProgressPhaseResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ProgressPhaseResponseFromJson(json);

  static Map<String, dynamic> toJson(ProgressPhaseResponse model) =>
      model == null ? null : _$ProgressPhaseResponseToJson(model);
}
