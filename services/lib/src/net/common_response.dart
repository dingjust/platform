import 'package:json_annotation/json_annotation.dart';

part 'common_response.g.dart';

///接口调用响应
@JsonSerializable()
class CommonResponse {
  int code;

  String msg;

  int resultCode;

  dynamic data;

  CommonResponse({this.code, this.msg, this.resultCode, this.data});

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CommonResponseFromJson(json);

  static Map<String, dynamic> toJson(CommonResponse model) =>
      model == null ? null : _$CommonResponseToJson(model);
}
