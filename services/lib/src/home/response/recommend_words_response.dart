import 'package:json_annotation/json_annotation.dart';

part 'recommend_words_response.g.dart';

/// 首页关键字响应
@JsonSerializable()
class RecommendWordsResponse {
  int code;

  int resultCode;

  List<Map<String, dynamic>> data;

  RecommendWordsResponse({this.code, this.resultCode, this.data});

  factory RecommendWordsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$RecommendWordsResponseFromJson(json);

  static Map<String, dynamic> toJson(RecommendWordsResponse model) =>
      model == null ? null : _$RecommendWordsResponseToJson(model);
}
