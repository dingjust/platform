import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 主图
class MasterPictureField extends StatefulWidget {
  MasterPictureField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _MasterPictureFieldState();
}

class _MasterPictureFieldState extends State<MasterPictureField> {
  List<File> _masterImages = [];

  Future<List<File>> _cachedImage(List<String> urls, List<File> files) async {
    var cacheManager = await CacheManager.getInstance();
    urls.forEach((url) async {
      var file = await cacheManager.getFile(url);
      files.add(file);
      print(files);
    });

//    CacheManager.inBetweenCleans = new Duration(days: 7);
    print(files);
    return files;
  }

  @override
  void initState() {
    super.initState();
    if (widget.item?.picture != null) {
      _cachedImage(widget.item?.picture, <File>[]).then((files) {
//        print(files);
        files.forEach((file) {
          setState(() {
            _masterImages.add(file);
          });
        });
      });
    }
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
        AlbumsAndCameras(
          images: _masterImages,
          height: 100,
          width: 100,
          iconSize: 100,
          count: 5,
        ),
      ],
    );
  }
}