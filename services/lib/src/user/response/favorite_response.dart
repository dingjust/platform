import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'favorite_response.g.dart';

/// 产品列表响应
@JsonSerializable()
class FavoriteResponse {
  final int number;
  final int size;
  final int totalPages;
  final int totalElements;
  final List<MyFavoriteModel> content;

  FavoriteResponse(this.number, this.size, this.totalPages, this.totalElements,
      this.content);

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$FavoriteResponseFromJson(json);

  static Map<String, dynamic> toJson(FavoriteResponse model) =>
      model == null ? null : _$FavoriteResponseToJson(model);
}
