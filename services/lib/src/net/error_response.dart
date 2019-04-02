import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  @JsonKey(toJson: _errorsToJson)
  List<Error> errors;

  ErrorResponse({this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  static Map<String, dynamic> toJson(ErrorResponse model) =>
      _$ErrorResponseToJson(model);

  static List<Map<String, dynamic>> _errorsToJson(List<Error> errors) =>
      errors.map((error) => Error.toJson(error)).toList();
}

@JsonSerializable()
class Error {
  String message;

  String type;

  Error({this.message, this.type});

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

  static Map<String, dynamic> toJson(Error error) => _$ErrorToJson(error);
}
