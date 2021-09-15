import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';

import '../../../widgets.dart';

class ImageSliverGrid extends StatelessWidget {
  final List<MediaModel> medias;

  const ImageSliverGrid({Key key, this.medias = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCountMap[getImages().length], //Grid按两列显示
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: childAspectRatioMap[getImages().length],
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          //创建子widget
          return _ImageItem(
            e: getImages()[index],
            onTap: () => onPreview(index, context),
          );
        },
        childCount: getImages().length,
      ),
    );
  }

  List<MediaModel> getImages() {
    if (medias != null) {
      if (medias.length > 9) {
        return medias.getRange(0, 9).toList();
      }
      return medias;
    }
    return [];
  }

  //图片预览
  void onPreview(int index, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems:
              getImages().map((model) => GalleryItem(model: model)).toList(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  final MediaModel e;

  final VoidCallback onTap;

  final String processUrl;

  const _ImageItem(
      {Key key,
      this.e,
      this.onTap,
      this.processUrl = 'image_process=resize,w_320/crop,mid,w_320,h_320'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        child: CachedNetworkImage(
          imageUrl: '${e.imageProcessUrl(processUrl)}',
          placeholder: (context, url) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
          errorWidget: (context, url, error) => SpinKitRing(
            color: Colors.grey[300],
            lineWidth: 2,
            size: 30,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

///图片列数
const crossAxisCountMap = {
  1: 1,
  2: 2,
  3: 3,
  4: 2,
  5: 3,
  6: 3,
  7: 3,
  8: 3,
  9: 3
};

///图片比列
const childAspectRatioMap = {
  1: 16 / 9,
  2: 4 / 3,
  3: 1.0,
  4: 4 / 3,
  5: 1.0,
  6: 1.0,
  7: 1.0,
  8: 1.0,
  9: 1.0
};
