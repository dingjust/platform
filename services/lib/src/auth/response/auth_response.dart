import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

/// 获取授权码响应
@JsonSerializable()
class AuthorizationCodeResponse {
  ///0失败 1成功
  final int code;

  ///响应信息
  final String msg;

  ///10001 账号未绑定 ; 10002获取access_token失败
  final int resultCode;

  ///授权码
  final String data;

  AuthorizationCodeResponse(this.code, this.msg, this.resultCode, this.data);

  factory AuthorizationCodeResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AuthorizationCodeResponseFromJson(json);

  static Map<String, dynamic> toJson(AuthorizationCodeResponse model) =>
      model == null ? null : _$AuthorizationCodeResponseToJson(model);
}
