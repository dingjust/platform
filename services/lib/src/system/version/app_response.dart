import 'package:json_annotation/json_annotation.dart';

part 'app_response.g.dart';

/// 需求订单列表响应
@JsonSerializable()
class AppVersionResponse {
  final int id;

  @JsonKey(fromJson: _dateTimefromMilliseconds)
  final DateTime creationtime;

  @JsonKey(fromJson: _dateTimefromMilliseconds)
  final DateTime modifiedtime;

  final String name;
  final String platform;
  final String description;
  final String releaseVersion;

  @JsonKey(fromJson: _dateTimefromMilliseconds)
  final DateTime releaseDate;

  final String releaseDescription;
  final String url;
  final bool force;

  AppVersionResponse(
      this.id,
      this.creationtime,
      this.modifiedtime,
      this.name,
      this.platform,
      this.description,
      this.releaseVersion,
      this.releaseDate,
      this.releaseDescription,
      this.url,
      this.force);

  factory AppVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$AppVersionResponseFromJson(json);

  static Map<String, dynamic> toJson(AppVersionResponse model) =>
      _$AppVersionResponseToJson(model);

  static DateTime _dateTimefromMilliseconds(int date) =>
      DateTime.fromMillisecondsSinceEpoch(date);
}
