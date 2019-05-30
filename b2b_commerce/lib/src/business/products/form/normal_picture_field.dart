import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 主图
class NormalPictureField extends StatefulWidget {
  NormalPictureField(this.item,{this.enabled = false});

  final ApparelProductModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _NormalPictureFieldState();
}

class _NormalPictureFieldState extends State<NormalPictureField> {
  @override
  void initState() {
    if(widget.item.images == null) widget.item.images = [];

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
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            ],
          ),
        ),
//        AlbumsAndCameras(
//          images: _normalImages,
//          pictureUrls: widget.item?.images,
//          height: 100,
//          width: 100,
//          iconSize: 100,
//          count: 5,
//        ),
          EditableAttachments(list: widget.item.images,editable: widget.enabled,)
      ],
    );
  }

}
