import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'carousel.g.dart';

@JsonSerializable()
class CarouselModel extends ItemModel {
  int id;

  String name;

  String description;

  @JsonKey(toJson: _mediaToJson)
  MediaModel media;

  bool active;

  CarouselType type;

  String group;

  String url;

  CarouselModel(
      {this.id,
      this.name,
      this.description,
      this.media,
      this.active,
      this.type,
      this.group,
      this.url});

  factory CarouselModel.fromJson(Map<String, dynamic> json) =>
      json == null ? null : _$CarouselModelFromJson(json);

  static Map<String, dynamic> toJson(CarouselModel model) =>
      model == null ? null : _$CarouselModelToJson(model);

  static Map<String, dynamic> _mediaToJson(MediaModel model) =>
      model == null ? null : MediaModel.toJson(model);
}

///轮播图类型
enum CarouselType {
  ///首页
  CT001,

  ///工厂首页
  CT002,

  ///品牌首页
  CT003,

  ///看款首页
  CT004,

  ///看款首页
  CT005
}

const CarouselTypeValuedMap = {
  CarouselType.CT001: "CT001",
  CarouselType.CT002: "CT002",
  CarouselType.CT003: "CT003",
  CarouselType.CT004: "CT004",
  CarouselType.CT005: "CT005",
};
