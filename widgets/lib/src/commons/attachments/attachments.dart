import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

//横向滚动图片列表
class Attachments extends StatefulWidget {
  Attachments(
      {Key key,
      @required this.list,
      this.width = 320,
      this.height = 100,
      this.imageWidth = 80,
      this.imageHeight = 80})
      : super(key: key);

  final List<MediaModel> list;

  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;

  _AttachmentsState createState() => _AttachmentsState();
}

class _AttachmentsState extends State<Attachments> {
  ScrollController _scrollController = new ScrollController();
  Color iconColorLeft = Colors.grey[200];
  Color iconColorRight = Colors.black;

  @override
  Widget build(BuildContext context) {
    //监听到底
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          iconColorRight = Colors.grey[200];
        });
      } else if (_scrollController.position.pixels == 0) {
        //监听开头
        setState(() {
          iconColorLeft = Colors.grey[200];
        });
      } else {
        setState(() {
          iconColorLeft = Colors.black;
          iconColorRight = Colors.black;
        });
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: iconColorLeft,
          ),
          tooltip: '上一张',
          onPressed: () {
            _scrollController.animateTo(_scrollController.position.pixels - 100,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
        Expanded(
          child: _buildAttachmentsListVie(widget.width, context),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: iconColorRight,
          ),
          tooltip: '下一张',
          onPressed: () {
            _scrollController.animateTo(_scrollController.position.pixels + 100,
                duration: Duration(milliseconds: 200), curve: Curves.ease);
          },
        ),
      ],
    );
  }

  Widget _buildAttachmentsListVie(double width, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: widget.height,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: widget.list.map(
          (model) {
            // 附件类型
            switch (model.mediaType) {
              case 'pdf':
                return GestureDetector(
                  child: CommonImage.pdf(),
                  onTap: () {
                    _previewFile(model.url, 'yijiayi',model.mediaType);
                  },
                );
                break;
              case 'docx':
                return GestureDetector(
                  child: CommonImage.word(),
                  onTap: () {
                    _previewFile(model.url,'yijiayi', model.mediaType);
                  },
                );
                break;
              case 'xlsx':
                return GestureDetector(
                  child: CommonImage.excel(),
                  onTap: () {
                    _previewFile(model.url,'yijiayi', model.mediaType);
                  },
                );
                break;
              default:
                return GestureDetector(
                  child: Container(
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(model.url),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    onPreview(context, model.url);
                  },
                );
            }
          },
        ).toList(),
      ),
    );
  }

  //图片预览
  void onPreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: PhotoView(
          imageProvider: NetworkImage(url),
        ));
      },
    );
  }

  //文件下载打开
  Future<String> _previewFile(String url,String name String mediaType) async {
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath="$dir/$name.$mediaType";
    var dio = new Dio();
    dio.onHttpClientCreate = (HttpClient client) {
      client.idleTimeout = new Duration(seconds: 0);
    };
    try {
      Response response = await dio.download(url, filePath,
          onProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
      });
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    //打开文件
    OpenFile.open(filePath);
    return filePath;
  }
}
