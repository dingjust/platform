import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// Image工厂类， 用于存放最通用的组件生成样式
class ImageFactory {
  /// 缩略图
  static Widget buildDefaultThumbnailImage(
      {double size = 60, double containerSize = 80}) {
    return Container(
      width: containerSize,
      height: containerSize,
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
    double containerSize = 80,
    BoxFit fit = BoxFit.fill,
  }) {
    // TODO：拿media format为Thumbnail的converted图片
    return Container(
        width: containerSize,
        height: containerSize,
        child: Container(
          width: containerSize,
          height: containerSize,
          child: CachedNetworkImage(
            imageUrl: '${media?.previewUrl() ?? ''}',
            // fit: fit,
            imageBuilder: (context, imageProvider) => Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10)),
            ),
            placeholder: (context, url) => SpinKitRing(
              color: Colors.black12,
              lineWidth: 2,
              size: 30,
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.photo_outlined,
              color: Colors.grey,
              size: size,
            ),
          ),
        ));
  }

  static Widget buildThumbnailImageForList(
    List<MediaModel> medias, {
    double size = 60,
    BoxFit fit = BoxFit.cover,
  }) {
    if (medias == null || medias.isEmpty) {
      return buildDefaultThumbnailImage();
    }

    return buildThumbnailImage(medias[0], fit: fit);
  }

  // 人物画像
  static Widget buildDefaultAvatar(MediaModel profilePicture,
      {double radius = 40.0}) {
    if (profilePicture == null) {
      return CircleAvatar(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        child: Container(
          padding: EdgeInsets.only(right: 5),
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
            size: 40,
          ),
        ),
        radius: radius,
      );
    }

    return CircleAvatar(
      backgroundImage: NetworkImage('${profilePicture.previewUrl()}'),
      radius: radius,
    );
  }
}
