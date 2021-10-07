import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// Image工厂类， 用于存放最通用的组件生成样式
class ImageFactory {
  /// 缩略图
  static Widget buildDefaultThumbnailImage(
      {double size = 33, double containerSize = 80}) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF0F0F0),
      ),
      child: Icon(
        B2BIcons.noPicture,
        color: Color.fromRGBO(200, 200, 200, 1),
        size: size,
      ),
    );
  }

  static Widget buildThumbnailImage(MediaModel media,
      {double size = 60,
      double containerSize = 80,
      BoxFit fit = BoxFit.fill,
      String processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320'}) {
    // TODO：拿media format为Thumbnail的converted图片
    return Container(
        width: containerSize,
        height: containerSize,
        child: Container(
          width: containerSize,
          height: containerSize,
          child: CachedNetworkImage(
            imageUrl: '${media?.imageProcessUrl(processUrl)}',
            // fit: fit,
            imageBuilder: (context, imageProvider) => Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12)),
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
    double size = 86,
    BoxFit fit = BoxFit.cover,
  }) {
    if (medias == null || medias.isEmpty) {
      return buildDefaultThumbnailImage(containerSize: size);
    }

    return buildThumbnailImage(
      medias[0],
      fit: fit,
      size: size,
    );
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

  // 圆形图片（带图片处理）
  static Widget buildProcessedAvatar(MediaModel profilePicture,
      {double radius = 40.0, String processurl}) {
    if (profilePicture == null) {
      return ClipOval(
        child: Container(
          width: radius,
          height: radius,
          color: Colors.grey[50],
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
      );
    }

    return ClipOval(
      child: CachedNetworkImage(
        width: radius,
        height: radius,
        imageUrl: '${profilePicture.imageProcessUrl(processurl)}',
        fit: BoxFit.cover,
        placeholder: (context, url) => SpinKitRing(
          color: Colors.grey[300],
          lineWidth: 2,
          size: 30,
        ),
        errorWidget: (context, url, error) => Icon(
          B2BIcons.noPicture,
          size: 30,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
