import 'package:json_annotation/json_annotation.dart';

part 'msg.g.dart';

@JsonSerializable()
class BaseMsg {
  int code;

  String msg;

  int resultCode;

  dynamic data;

  BaseMsg({this.code, this.msg, this.resultCode,this.data});

  factory BaseMsg.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BaseMsgFromJson(json);

  static Map<String, dynamic> toJson(BaseMsg model) =>
      model == null ? null : _$BaseMsgToJson(model);
}
