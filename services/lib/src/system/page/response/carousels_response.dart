import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'carousels_response.g.dart';

/// 轮播图响应
@JsonSerializable()
class CarouselsResponse {
  final int code;
  final String msg;
  final int resultCode;
  final List<CarouselModel> data;

  CarouselsResponse(this.code, this.msg, this.resultCode, this.data);

  factory CarouselsResponse.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CarouselsResponseFromJson(json);

  static Map<String, dynamic> toJson(CarouselsResponse model) =>
      model == null ? null : _$CarouselsResponseToJson(model);
}
