import 'package:json_annotation/json_annotation.dart';

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

enum MsgModule {

///用户登录
@JsonValue('userLogin')
UserLogin,

///用户注册
@JsonValue('register')
REGISTER,

///新报价
@JsonValue('newQuote')
QUOTE_NEW,

///拒绝报价
@JsonValue('refuseQuote')
QUOTE_REFUSE,

///通过报价
@JsonValue('adoptedQuote')
QUOTE_ADOPTED,

///打样订单创建
@JsonValue('proofingCreate')
PROOFING_CREATE,

///打样订单确认发货
@JsonValue('proofingDeliver')
PROOFING_DELIVER,

///打样订单确认收货
@JsonValue('proofingReceived')
PROOFING_RECEIVED,

///打样订单确认发货
@JsonValue('purchaseDeliver')
PURCHASE_DELIVER,

///打样订单确认收货
@JsonValue('purchaseReceived')
PURCHASE_RECEIVED}
