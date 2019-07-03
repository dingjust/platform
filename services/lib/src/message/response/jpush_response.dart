import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'jpush_response.g.dart';

abstract class JPushResponse {}

///JPush安卓响应
@JsonSerializable()
class JPushAndroidResponse extends JPushResponse {
  String alert;

  String title;

  @JsonKey(fromJson: extrasFromJson)
  JPushAndroidResponseExtras extras;

  JPushAndroidResponse({this.alert, this.title, this.extras});

  factory JPushAndroidResponse.fromJson(Map<String, dynamic> json) =>
      _$JPushAndroidResponseFromJson(json);

  static Map<String, dynamic> toJson(JPushAndroidResponse model) =>
      _$JPushAndroidResponseToJson(model);

  static JPushAndroidResponseExtras extrasFromJson(Map<dynamic, dynamic> map) {
    return JPushAndroidResponseExtras(
        alertType: map['cn.jpush.android.ALERT_TYPE'] as String,
        notificationId: map['cn.jpush.android.NOTIFICATION_ID'] as int,
        androidExtras: map['cn.jpush.android.EXTRA'] == null
            ? null
            : Extras.fromJson(json.decode(map['cn.jpush.android.EXTRA'])
                as Map<String, dynamic>));
  }
}

@JsonSerializable()
class JPushAndroidResponseExtras {
  @JsonValue('cn.jpush.android.ALERT_TYPE')
  String alertType;

  @JsonValue('cn.jpush.android.NOTIFICATION_ID')
  int notificationId;

  @JsonValue('cn.jpush.android.EXTRA')
  Extras androidExtras;

  JPushAndroidResponseExtras(
      {this.alertType, this.notificationId, this.androidExtras});

  factory JPushAndroidResponseExtras.fromJson(Map<String, dynamic> json) =>
      _$JPushAndroidResponseExtrasFromJson(json);

  static Map<String, dynamic> toJson(JPushAndroidResponseExtras model) =>
      _$JPushAndroidResponseExtrasToJson(model);
}

@JsonSerializable()
class Extras {
  MsgModule module;

  String params;

  Extras({this.module, this.params});

  factory Extras.fromJson(Map<String, dynamic> json) => _$ExtrasFromJson(json);

  static Map<String, dynamic> toJson(Extras model) => _$ExtrasToJson(model);
}


///JPush安卓响应
@JsonSerializable()
class JPushIOSResponse extends JPushResponse {

  String params;

  String module;

  JPushIOSResponse({this.params, this.module});

  factory JPushIOSResponse.fromJson(Map<String, dynamic> json) =>
      _$JPushIOSResponseFromJson(json);

  static Map<String, dynamic> toJson(JPushIOSResponse model) =>
      _$JPushIOSResponseToJson(model);
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
