import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'bills_response.g.dart';

///账单列表响应
@JsonSerializable()
class BillsResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<BillModel> content;

  BillsResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory BillsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BillsResponseFromJson(json);

  static Map<String, dynamic> toJson(BillsResponse model) =>
      model == null ? null : _$BillsResponseToJson(model);
}
