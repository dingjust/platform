import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'my_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class UserGuidelineResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<UserGuidelineModel> content;

  UserGuidelineResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory UserGuidelineResponse.fromJson(Map<String, dynamic> json) =>
      _$UserGuidelineResponseFromJson(json);

  static Map<String, dynamic> toJson(UserGuidelineResponse model) =>
      _$UserGuidelineResponseToJson(model);
}


@JsonSerializable()
class NotifyResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<NotifyModel> content;

  NotifyResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory NotifyResponse.fromJson(Map<String, dynamic> json) =>
      _$NotifyResponseFromJson(json);

  static Map<String, dynamic> toJson(NotifyResponse model) =>
      _$NotifyResponseToJson(model);
}

@JsonSerializable()
class ContractResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ContractModel> content;

  ContractResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory ContractResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractResponseFromJson(json);

  static Map<String, dynamic> toJson(ContractResponse model) =>
      _$ContractResponseToJson(model);
}


@JsonSerializable()
class ContractTempResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<ContractTemplateModel> content;

  ContractTempResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory ContractTempResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractTempResponseFromJson(json);

  static Map<String, dynamic> toJson(ContractTempResponse model) =>
      _$ContractTempResponseToJson(model);
}

@JsonSerializable()
class SealResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<SealModel> content;

  SealResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory SealResponse.fromJson(Map<String, dynamic> json) =>
      _$SealResponseFromJson(json);

  static Map<String, dynamic> toJson(SealResponse model) =>
      _$SealResponseToJson(model);
}