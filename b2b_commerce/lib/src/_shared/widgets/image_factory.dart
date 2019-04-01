import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

/// Image工厂类， 用于存放最通用的组件生成样式
class ImageFactory {
  static Widget buildDefaultThumbnailImage() {
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
        size: 60,
      ),
    );
  }

  static Widget buildThumbnailImage(MediaModel media) {
    if (media == null) {
      return buildDefaultThumbnailImage();
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
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
