import 'package:core/core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:models/models.dart';

part 'media.g.dart';

@JsonSerializable()
class MediaModel extends ItemModel {
  /// id

  int id;

  /// 文件名
  String name;

  /// URL地址
  String url;

  /// 文件类型
  String mediaType;

  /// mime
  String mime;

  /// mediaFormat
  String mediaFormat;

  /// 多格式图片组
  @JsonKey(
    toJson: convertedMediasToJson,
    // fromJson: _fromConvertedMedias
  )
  List<MediaModel> convertedMedias;

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

  static void populatorMedia(MediaModel source,MediaModel target){
    source.name = target.name;
    source.id = target.id;
    source.url = target.url;
    source.convertedMedias = target.convertedMedias;
    source.mime = target.mime;
    source.mediaFormat = target.mediaFormat;
    source.mediaType = target.mediaType;
  }

  static void clearMedia(MediaModel source,MediaModel target){
    source.name = null;
    source.id = null;
    source.url = null;
    source.convertedMedias = null;
    source.mime = null;
    source.mediaFormat = null;
    source.mediaType = null;
  }

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

  String get actualUrl => '${GlobalConfigs.MEDIA_CONTEXT_PATH}${url}';

  ///workingUrl
  String workingUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_WORKING_FORMAT]);

    if (mediaModel != null) {
      // print('${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}');
      return '${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///预览图
  String previewUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_PREVIEW]);

    if (mediaModel != null) {
      // print('${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}');
      return '${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///主图
  String thumbnailUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_THUMBNAIL]);

    if (mediaModel != null) {
      return '${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///详情图
  String detailUrl() {
    MediaModel mediaModel =
        getFormatMedia(MediaFormatMap[MediaFormat.DEFAULT_PRODUCT_DETAIL]);

    if (mediaModel != null) {
      return '${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}';
    } else {
      return actualUrl;
    }
  }

  ///常规图
  String normalUrl() {
    MediaModel mediaModel = getFormatMedia(MediaFormatMap[MediaFormat.NORMAL]);
    if (mediaModel != null) {
      // print('NORMAL:${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}');
      return '${GlobalConfigs.MEDIA_CONTEXT_PATH}${mediaModel.url}';
    } else {
      // print('ACTUAL:${actualUrl}');
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

/// 图片类型
enum MediaFormat {
  /// 默认
  DEFAULT_IMAGE_FORMAT,

  DEFAULT_PRODUCT_WORKING_FORMAT,

  ///详情
  DEFAULT_PRODUCT_DETAIL,

  //主图
  DEFAULT_PRODUCT_THUMBNAIL,

  ///缩略图
  DEFAULT_PRODUCT_PREVIEW,

  NORMAL
}

const MediaFormatMap = {
  MediaFormat.DEFAULT_IMAGE_FORMAT: "DefaultImageFormat",
  MediaFormat.DEFAULT_PRODUCT_WORKING_FORMAT: "DefaultProductWorkingFormat",
  MediaFormat.DEFAULT_PRODUCT_DETAIL: "DefaultProductDetail",
  MediaFormat.DEFAULT_PRODUCT_THUMBNAIL: "DefaultProductThumbnail",
  MediaFormat.DEFAULT_PRODUCT_PREVIEW: "DefaultProductPreview",
  MediaFormat.NORMAL: 'DefaultProductNormal'
};
