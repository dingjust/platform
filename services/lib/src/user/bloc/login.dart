import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  LoginRequest(this.username, this.password);

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  static Map<String, dynamic> toJson(LoginRequest model) =>
      _$LoginRequestToJson(model);
}

///
/// {
///    "access_token": "42ac80f3-726a-434c-94bd-f94dd52e1028",
///    "token_type": "bearer",
///    "refresh_token": "16a85969-8a94-4220-a5ef-273f93649f5a",
///    "expires_in": 43199,
///    "scope": "basic openid"
/// }
///
@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'token_type')
  final String tokenType;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(name: 'expires_in')
  final int expiresIn;

  @JsonKey(name: 'scope')
  final String scope;

  LoginResponse(this.accessToken, this.tokenType, this.refreshToken, this.expiresIn, this.scope);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  static Map<String, dynamic> toJson(LoginResponse model) =>
      _$LoginResponseToJson(model);
}
