import 'package:json_annotation/json_annotation.dart';

part 'error_response.g.dart';

@JsonSerializable()
class ErrorResponse {
  @JsonKey(toJson: _errorsToJson)
  List<Error> errors;

  ErrorResponse({this.errors});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ErrorResponseFromJson(json);

  static Map<String, dynamic> toJson(ErrorResponse model) =>
      model == null ? null : _$ErrorResponseToJson(model);

  static List<Map<String, dynamic>> _errorsToJson(List<Error> errors) =>
      errors == null
          ? null
          : errors.map((error) => Error.toJson(error)).toList();
}

@JsonSerializable()
class Error {
  String message;

  String type;

  Error({this.message, this.type});

  factory Error.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$ErrorFromJson(json);

  static Map<String, dynamic> toJson(Error error) =>
      error == null ? null : _$ErrorToJson(error);
}
