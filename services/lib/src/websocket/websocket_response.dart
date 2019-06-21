import 'package:json_annotation/json_annotation.dart';

part 'websocket_response.g.dart';

@JsonSerializable()
class WebsocketResponse {
  ///消息主题
  String body;

  ///标题
  String title;

  ///类型
  String type;

  ///HTML URL
  String openUrl;

  ///app跳转
  String openTarget;

  ///额外消息
  String extra;

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
