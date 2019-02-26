import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class DetailPictureField extends StatefulWidget {
  DetailPictureField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _DetailPictureFieldState();
}

class _DetailPictureFieldState extends State<DetailPictureField> {
  List<File> _detailImages = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                '上传详情图',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '（最多8张）',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
        AlbumsAndCameras(
//          pictureUrls: widget.item?.detail.,
          images: _detailImages,
          height: 100,
          width: 100,
          iconSize: 100,
          count: 8,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
