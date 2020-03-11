import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'authorization_response.g.dart';

/// 权限列表响应
@JsonSerializable()
class AuthorizationResponse {
  final int code;
  final String msg;
  final int resultCode;

  @JsonKey(fromJson: _authorizationFromJson)
  final List<Authorization> data;

  AuthorizationResponse(this.code, this.msg, this.resultCode, this.data);

  factory AuthorizationResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$AuthorizationResponseFromJson(json);

  static Map<String, dynamic> toJson(AuthorizationResponse model) =>
      model == null ? null : _$AuthorizationResponseToJson(model);

  static List<Authorization> _authorizationFromJson(List<dynamic> data) {
    List<Authorization> result = [];
    data.forEach((item) {
      Authorization val = _$enumDecodeNullable(_$AuthorizationEnumMap, item,
          unknownValue: Authorization.UNKNOWNVALUE);
      if (val != null) {
        result.add(val);
      }
    });
    return result;
  }
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null) {
    print('===================未知枚举值:$source');
  }

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}
