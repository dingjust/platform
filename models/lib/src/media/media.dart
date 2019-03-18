import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'media.g.dart';

@JsonSerializable()
class MediaModel extends ItemModel {
  /// id

  final int id;

  /// 文件名
  final String name;

  /// URL地址
  final String url;

  /// 文件类型
  final String mediaType;

  /// mime
  final String mime;

  /// mediaFormat
  final String mediaFormat;

  /// 多格式图片组
  @JsonKey(toJson: convertedMediasToJson)
  final List<MediaModel> convertedMedias;

  MediaModel(
      {this.id,
      this.name,
      this.url,
      this.mime,
      this.mediaFormat,
      this.mediaType,
      this.convertedMedias});

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  static Map<String, dynamic> toJson(MediaModel model) =>
      _$MediaModelToJson(model);

  static List<String> convertedMediasToJson(
          List<MediaModel> convertedMedias) =>
      null;
}
