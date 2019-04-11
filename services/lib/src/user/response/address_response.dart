import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'address_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class AddressResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<AddressModel> content;

  AddressResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseFromJson(json);

  static Map<String, dynamic> toJson(AddressResponse model) =>
      _$AddressResponseToJson(model);
}

