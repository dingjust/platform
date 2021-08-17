import 'package:flutter/widgets.dart';
import 'package:models/models.dart';

class GalleryItem {
  GalleryItem(
      {this.model,
      this.watermark = false,
      this.waterProcessParams =
          'image_process=watermark,text_6ZKJ5Y2V,fill_1,color_F5F5F5,t_50'});

  final MediaModel? model;

  final bool watermark;

  ///水印处理参数
  final String waterProcessParams;
}

class GalleryItemThumbnail extends StatelessWidget {
  const GalleryItemThumbnail({Key? key, this.galleryExampleItem, this.onTap})
      : super(key: key);

  final GalleryItem? galleryExampleItem;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: galleryExampleItem!.model!.id,
          child: Image.network(galleryExampleItem!.model!.normalUrl(),
              height: 80.0),
        ),
      ),
    );
  }
}

// List<GalleryItem> galleryItems = <GalleryItem>[
//   GalleryItem(
//     id: "tag1",
//     resource: "assets/gallery1.jpg",
//   ),
//   GalleryItem(id: "tag2", resource: "assets/firefox.svg", isSvg: true),
//   GalleryItem(
//     id: "tag3",
//     resource: "assets/gallery2.jpg",
//   ),
//   GalleryItem(
//     id: "tag4",
//     resource: "assets/gallery3.jpg",
//   ),
// ];
