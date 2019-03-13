import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PicturesField extends StatefulWidget{
  List<File> normalImages;
  PicturesField(this.normalImages);

  PicturesFieldState createState() => PicturesFieldState();
}

class PicturesFieldState extends State<PicturesField>{
  List<MediaModel> medias = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '参考图片',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '（若无图片可不上传）',
                style: TextStyle(color: Colors.red, fontSize: 14),
              )
            ],
          ),
        ),
//        PhotoPicker(images: widget.normalImages, width: 350),
        EditableAttachments(
          list: medias,
//          maxNum: widget.normalImages.length,
        )
      ],
    );
  }
}