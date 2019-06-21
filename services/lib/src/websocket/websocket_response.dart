import 'package:json_annotation/json_annotation.dart';

part 'websocket_response.g.dart';

@JsonSerializable()

///Socket消息 class WebsocketResponse {
  ///消息主题
  final String body;

  ///标题
  final String title;

  ///类型
  final String type;

  ///HTML URL
  final String openUrl;

  ///app跳转
  final String openTarget;

  ///额外消息
  final String extra;

  WebsocketResponse({
    this.body,
    this.title,
    this.type,
    this.openUrl,
    this.openTarget,
    this.extra,
  });

  factory WebsocketResponse.fromJson(Map<String, dynamic> json) =>
      _$WebsocketResponseFromJson(json);

  static Map<String, dynamic> toJson(WebsocketResponse model) =>
      _$WebsocketResponseToJson(model);
}
