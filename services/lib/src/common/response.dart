import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

/// 响应
@JsonSerializable()
class BaseResponse {
  ///0失败 1成功
  final int code;

  ///响应信息
  final String msg;

  final int resultCode;

  ///数据
  final dynamic data;

  BaseResponse(this.code, this.msg, this.resultCode, this.data);

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$BaseResponseFromJson(json);

  static Map<String, dynamic> toJson(BaseResponse model) =>
      model == null ? null : _$BaseResponseToJson(model);
}
