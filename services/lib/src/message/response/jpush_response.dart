import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

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
      json == null ? null : _$JPushAndroidResponseFromJson(json);

  static Map<String, dynamic> toJson(JPushAndroidResponse model) =>
      model == null ? null : _$JPushAndroidResponseToJson(model);

  static JPushAndroidResponseExtras extrasFromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return null;
    }
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
      json == null ? null : _$JPushAndroidResponseExtrasFromJson(json);

  static Map<String, dynamic> toJson(JPushAndroidResponseExtras model) =>
      model == null ? null : _$JPushAndroidResponseExtrasToJson(model);
}

@JsonSerializable()
class Extras {
  MsgModule module;

  String params;

  Extras({this.module, this.params});

  factory Extras.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ExtrasFromJson(json);

  static Map<String, dynamic> toJson(Extras model) =>
      model == null ? null : _$ExtrasToJson(model);
}

///JPush安卓响应
@JsonSerializable()
class JPushIOSResponse extends JPushResponse {
  String params;

  MsgModule module;

  JPushIOSResponse({this.params, this.module});

  factory JPushIOSResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$JPushIOSResponseFromJson(json);

  static Map<String, dynamic> toJson(JPushIOSResponse model) =>
      model == null ? null : _$JPushIOSResponseToJson(model);
}
