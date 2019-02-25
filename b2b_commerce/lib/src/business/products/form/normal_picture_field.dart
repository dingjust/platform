import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 主图
class NormalPictureField extends StatefulWidget {
  NormalPictureField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _NormalPictureFieldState();
}

class _NormalPictureFieldState extends State<NormalPictureField> {
  List<MediaModel> _normalMedias = [];
  List<File> _normalImages = [];

  @override
  void initState() {
    if(widget.item?.normal != null) _normalMedias = widget.item?.normal;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '上传主图',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '（最多5张）',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
        ),
//        AlbumsAndCameras(
//          images: _normalImages,
//          pictureUrls: widget.item?.normal,
//          height: 100,
//          width: 100,
//          iconSize: 100,
//          count: 5,
//        ),
        widget.item != null
            ? EditableAttachments(list: _normalMedias)
            : PhotoPicker(images: _normalImages, width: 350),
      ],
    );
  }

}
