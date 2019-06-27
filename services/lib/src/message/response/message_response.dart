import 'package:json_annotation/json_annotation.dart';

part 'message_response.g.dart';

///未读消息统计响应
@JsonSerializable()
class CountUnreadResponse {
  final int order;
  final int system;
  final int finance;

  CountUnreadResponse({this.order, this.system, this.finance});

  factory CountUnreadResponse.fromJson(Map<String, dynamic> json) =>
      _$CountUnreadResponseFromJson(json);

  static Map<String, dynamic> toJson(CountUnreadResponse model) =>
      _$CountUnreadResponseToJson(model);
}
