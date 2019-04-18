import 'package:core/core.dart';
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
  @JsonKey(
    toJson: convertedMediasToJson,
    // fromJson: _fromConvertedMedias
  )
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

  static List<String> convertedMediasToJson(List<MediaModel> convertedMedias) =>
      null;

  // static List<MediaModel> _fromConvertedMedias(List<dynamic> medias) =>
  //     medias.map((media) {
  //       return MediaModel(
  //           id: media.id,
  //           name: media.name,
  //           url: media.url,
  //           mime: media.mime,
  //           mediaFormat: media.mediaFormat,
  //           mediaType: media.mediaType);
  //     }).toList();

  String get actualUrl => '${GlobalConfigs.CONTEXT_PATH}${url}';

  ///预览图
  String previewUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_PREVIEW]);

    if (mediaModel != null) {
      return '${GlobalConfigs.CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///主图
  String thumbnailUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_THUMBNAIL]);

    if (mediaModel != null) {
      return '${GlobalConfigs.CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///详情图
  String detailUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_DETAIL]);

    if (mediaModel != null) {
      return '${GlobalConfigs.CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  MediaModel getFormatMedia(String mediaFormat) {
    MediaModel result;
    if (convertedMedias == null || convertedMedias.isEmpty) {
      return null;
    } else {
      convertedMedias.forEach((media) {
        if (media.mediaFormat == mediaFormat) {
          result = media;
        }
      });
      return result;
    }
  }
}

/// 样衣归还状态
enum MediaFormat {
  /// 默认
  DEFAULT_IMAGE_FORMAT,

  DEFAULT_PRODUCT_WORKING_FORMAT,

  ///详情
  DEFAULT_PRODUCT_DETAIL,

  //主图
  DEFAULT_PRODUCT_THUMBNAIL,

  ///缩略图
  DEFAULT_PRODUCT_PREVIEW
}

const MediaFormatMap = {
  MediaFormat.DEFAULT_IMAGE_FORMAT: "DefaultImageFormat",
  MediaFormat.DEFAULT_PRODUCT_WORKING_FORMAT: "DefaultProductWorkingFormat",
  MediaFormat.DEFAULT_PRODUCT_DETAIL: "DefaultProductDetail",
  MediaFormat.DEFAULT_PRODUCT_THUMBNAIL: "DefaultProductThumbnail",
  MediaFormat.DEFAULT_PRODUCT_PREVIEW: "DefaultProductPreview",
};
