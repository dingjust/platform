import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

///视频缩略图组件
class RemoteVideoItem extends StatefulWidget {
  final String url;

  final double width;

  final double height;

  const RemoteVideoItem(
    this.url, {
    Key key,
    this.width = 60,
    this.height = 60,
  }) : super(key: key);

  @override
  _RemoteVideoItemState createState() => _RemoteVideoItemState();
}

class _RemoteVideoItemState extends State<RemoteVideoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: FutureBuilder<ThumbnailResult>(
          builder:
              (BuildContext context, AsyncSnapshot<ThumbnailResult> snapshot) {
            if (snapshot.data != null) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: [
                  snapshot.data.image,
                  Container(
                    color: Colors.black26,
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              );
            } else {
              return Container(
                color: Colors.grey,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          initialData: null,
          future: _getData(widget.url, widget.width, widget.height),
        ));
  }
}

class ThumbnailResult {
  final Image image;
  final int dataSize;
  final int height;
  final int width;

  const ThumbnailResult({this.image, this.dataSize, this.height, this.width});
}

Future<ThumbnailResult> _getData(
    String url, double maxHeight, double maxWidth) async {
  Uint8List bytes;

  final Completer<ThumbnailResult> completer = Completer();

  bytes = await VideoThumbnail.thumbnailData(
      video: url,
      imageFormat: ImageFormat.WEBP,
      maxHeight: maxHeight.toInt(),
      maxWidth: maxWidth.toInt(),
      quality: 75);

  int _imageDataSize = bytes.length;

  final _image = Image.memory(
    bytes,
    width: maxWidth,
    height: maxHeight,
    fit: BoxFit.cover,
  );
  _image.image
      .resolve(ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(ThumbnailResult(
      image: _image,
      dataSize: _imageDataSize,
      height: info.image.height,
      width: info.image.width,
    ));
  }));
  return completer.future;
}
