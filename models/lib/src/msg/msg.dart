import 'package:json_annotation/json_annotation.dart';

part 'msg.g.dart';

@JsonSerializable()
class BaseMsg {
  int? code;

  String? msg;

  int? resultCode;

  dynamic? data;

  BaseMsg({this.code, this.msg, this.resultCode, this.data});

  factory BaseMsg.fromJson(Map<String, dynamic> json) =>
      _$BaseMsgFromJson(json);

  Map<String, dynamic> toJson() => _$BaseMsgToJson(this);
}
