import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

/// Image工厂类， 用于存放最通用的组件生成样式
class ImageFactory {
  static Widget buildDefaultThumbnailImage({double size = 60}) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(243, 243, 243, 1),
      ),
      child: Icon(
        B2BIcons.noPicture,
        color: Color.fromRGBO(200, 200, 200, 1),
        size: size,
      ),
    );
  }

  static Widget buildThumbnailImage(
    MediaModel media, {
    double size = 60,
    BoxFit fit = BoxFit.fill,
  }) {
    if (media == null) {
      return buildDefaultThumbnailImage(size: size);
    }

    // TODO：拿media format为Thumbnail的converted图片
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${media.url}'),
          fit: fit,
        ),
      ),
    );
  }

  static Widget buildThumbnailImageForList(
    List<MediaModel> medias, {
    double size = 60,
    BoxFit fit = BoxFit.fill,
  }) {
    if (medias == null || medias.isEmpty) {
      return buildDefaultThumbnailImage();
    }

    return buildThumbnailImage(medias[0], fit: fit);
  }
}
