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

