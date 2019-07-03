import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'jpush_response.g.dart';

///JPush响应
@JsonSerializable()
class JPushResponse {
  String alert;

  String title;

  @JsonKey(fromJson: extrasFromJson)
  JPushResponseExtras extras;

  JPushResponse({this.alert, this.title, this.extras});

  factory JPushResponse.fromJson(Map<String, dynamic> json) =>
      _$JPushResponseFromJson(json);

  static Map<String, dynamic> toJson(JPushResponse model) =>
      _$JPushResponseToJson(model);

  static JPushResponseExtras extrasFromJson(Map<dynamic, dynamic> map) {
    return JPushResponseExtras(
        alertType: map['cn.jpush.android.ALERT_TYPE'] as String,
        notificationId: map['cn.jpush.android.NOTIFICATION_ID'] as int,
        androidExtras: map['cn.jpush.android.EXTRA'] == null
            ? null
            : Extras.fromJson(json.decode(map['cn.jpush.android.EXTRA'])
                as Map<String, dynamic>));
  }
}

@JsonSerializable()
class JPushResponseExtras {
  @JsonValue('cn.jpush.android.ALERT_TYPE')
  String alertType;

  @JsonValue('cn.jpush.android.NOTIFICATION_ID')
  int notificationId;

  @JsonValue('cn.jpush.android.EXTRA')
  Extras androidExtras;

  JPushResponseExtras(
      {this.alertType, this.notificationId, this.androidExtras});

  factory JPushResponseExtras.fromJson(Map<String, dynamic> json) =>
      _$JPushResponseExtrasFromJson(json);

  static Map<String, dynamic> toJson(JPushResponseExtras model) =>
      _$JPushResponseExtrasToJson(model);
}

@JsonSerializable()
class Extras {
  MsgModule module;

  String params;

  Extras({this.module, this.params});

  factory Extras.fromJson(Map<String, dynamic> json) => _$ExtrasFromJson(json);

  static Map<String, dynamic> toJson(Extras model) => _$ExtrasToJson(model);
}

enum MsgModule {
  ///默认
  @JsonValue('default')
  DEFAULT,

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
  PURCHASE_RECEIVED
}
