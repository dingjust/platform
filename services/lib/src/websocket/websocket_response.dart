import 'package:json_annotation/json_annotation.dart';
import 'package:services/src/message/response/jpush_response.dart';

part 'websocket_response.g.dart';

@JsonSerializable()
class WebsocketResponse {
  String id;

  ///消息类型
  // MsgType type;

  ///标题
  String title;

  ///用户ID
  String userIds;

  String tokens;

  ///消息主题
  String body;

  ///模块
  MsgModule module;

  ///参数
  String params;

  ///消息组  1订单 2.系统 3.财务
  int group;

  ///额外消息
  dynamic extra;

  ///跳转URL
  String openUrl;

  ///内部跳转
  String openTarget;

  WebsocketResponse({this.id,
    this.title,
    this.userIds,
    this.tokens,
    this.body,
    this.module,
    this.params,
    this.group,
    this.extra,
    this.openUrl,
    this.openTarget});

  factory WebsocketResponse.fromJson(Map<String, dynamic> json) =>
      _$WebsocketResponseFromJson(json);

  static Map<String, dynamic> toJson(WebsocketResponse model) =>
      _$WebsocketResponseToJson(model);
}