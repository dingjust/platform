import 'package:json_annotation/json_annotation.dart';

part 'msg.g.dart';

@JsonSerializable()
class BaseMsg {
  int code;

  String msg;

  int resultCode;

  BaseMsg({this.code, this.msg, this.resultCode});

  factory BaseMsg.fromJson(Map<String, dynamic> json) =>
      _$BaseMsgFromJson(json);

  static Map<String, dynamic> toJson(BaseMsg model) => _$BaseMsgToJson(model);
}
