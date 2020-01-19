import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'b2b_customer_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class B2BCustomerResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<B2BCustomerModel> content;

  B2BCustomerResponse(this.number, this.size, this.totalPages,
      this.totalElements, this.content);

  factory B2BCustomerResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$B2BCustomerResponseFromJson(json);

  static Map<String, dynamic> toJson(B2BCustomerResponse model) =>
      model == null ? null : _$B2BCustomerResponseToJson(model);
}
