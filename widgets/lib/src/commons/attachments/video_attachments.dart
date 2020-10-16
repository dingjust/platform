import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/src/commons/attachments/remote_video_item.dart';
import 'package:widgets/src/commons/attachments/video_page.dart';
import 'package:widgets/src/commons/photo_picker/image_picker_video_handler.dart';

///视频附件
class VideoAttachments extends StatefulWidget {
  VideoAttachments({
    Key key,
    @required this.list,
    this.editable = true,
    this.maxNum = 5,
    this.uploadURL,
    this.loogPressDelete = true,
    this.width = 320,
    this.height = 80,
    this.itemWidth = 60,
    this.itemHeight = 60,
  }) : super(key: key);

  final List<MediaModel> list;

  final double width;
  final double height;

  ///图片宽度
  final double itemWidth;

  ///图片高度
  final double itemHeight;

  //是否可编辑
  final bool editable;

  ///凭证最大数
  final int maxNum;

  ///上传URL
  final String uploadURL;

  //是否长按删除
  final bool loogPressDelete;

  _VideoAttachmentsState createState() => _VideoAttachmentsState();
}

class _VideoAttachmentsState extends State<VideoAttachments>
    with TickerProviderStateMixin, ImagePickerVideoListener {
  ScrollController _scrollController = new ScrollController();
  Color iconColorLeft = Colors.grey[200];
  Color iconColorRight = Colors.black;

  final StreamController _streamController =
      StreamController<double>.broadcast();

  final StreamController _compressStreamController =
      StreamController<double>.broadcast();

  List<File> _uploadFileList = [];
  List<StreamController> _streamControllerList = [];

  AnimationController _controller;
  ImagePickerVideoHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerVideoHandler(this, _controller);
    imagePicker.build(0xFFFFFFFF, 0xFF6495ED);
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamController.close();
    _compressStreamController.close();
    super.dispose();
  }

  @override
  useVideo(File _image) async {
    if (widget.maxNum == 1) {
      widget.list.clear();
    }
    if (_image != null) {
      await _uploadFile(_image);
    }
  }

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
          child: _buildVideoAttachmentsListView(widget.width, context),
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

  Widget _buildVideoAttachmentsListView(double width, BuildContext context) {
    List<Widget> widgetList = [];

    //间隔值
    const double marginVal = 10;

    //是否已达限制数量，添加图片按钮
    if (widget.list.length < widget.maxNum && widget.editable) {
      widgetList.add(GestureDetector(
        onTap: () {
          imagePicker.showDialog(context);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: marginVal),
          width: widget.itemWidth,
          height: widget.itemHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300], width: 1.0)),
          child: Center(
            child: Icon(
              Icons.add,
              size: widget.itemWidth,
              color: Colors.grey,
            ),
          ),
        ),
      ));
    } else {
      //空白间隔位
      widgetList.add(Container(
        width: marginVal,
      ));
    }

    //上传中的图片
    for (int i = 0; i < _uploadFileList.length; i++) {
      widgetList.add(GestureDetector(
        child: Container(
          width: widget.itemWidth,
          height: widget.itemHeight,
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(
                _uploadFileList[i],
              ),
              Container(
                width: widget.itemWidth,
                height: widget.itemHeight,
                color: Colors.black26,
              ),
              StreamBuilder<double>(
                  stream: _streamControllerList[i].stream,
                  initialData: 0.0,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    return Center(
                      child: CircularProgressIndicator(
                        value: snapshot.data,
                      ),
                    );
                  })
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () {},
        onLongPress: () {},
      ));
    }

    widgetList.addAll(widget.list.reversed.map(
      (model) {
        // 附件类型
        switch (model.mediaType) {
          // case 'application/pdf':
          //   return GestureDetector(
          //     child: CommonImage.pdf(),
          //     onTap: () {
          //       _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
          //     },
          //     onLongPress: () {
          //       _deleteFile(model);
          //     },
          //   );
          //   break;
          default:
            return GestureDetector(
              child: Container(
                width: widget.itemWidth,
                height: widget.itemHeight,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: RemoteVideoItem(model.actualUrl),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
              onTap: () {
                // onPreview(context, '${model.detailUrl()}', '${model.name}');
                onPreview(context, model);
                print('onp');
              },
              onLongPress: () {
                if (widget.editable) _deleteFile(model);
              },
            );
        }
      },
    ).toList());

    return Container(
      padding: EdgeInsets.all(10),
      height: widget.height,
      width: width,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: widgetList,
      ),
    );
  }

  //图片预览
  void onPreview(BuildContext context, MediaModel model) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => VideoPage(model.actualUrl)));
  }

  Future _uploadFile(File file) async {
    //上传文件置入列表
    int index = _addFile(file);
    //调用上传接口,更新上传进度条
    try {
      FormData formData = FormData.fromMap({
        // "file": UploadFileInfo(file, "file",
        //     contentType: ContentType.parse('image/jpeg')),
        "file": await MultipartFile.fromFile(file.path, filename: "file"),
        "conversionGroup": "DefaultProductConversionGroup",
        "imageFormat": "DefaultImageFormat"
      });
      Response<Map<String, dynamic>> response = await http$.post(
        Apis.upload(),
        data: formData,
        // queryParameters: {'conversionGroup': 'DefaultProductConversionGroup'},
        // queryParameters: {'imageFormat': 'DefaultImageFormat'},
        // options: Options(
        //   headers: {'Content-Type': 'application/json;charset=UTF-8'},
        // ),
        onSendProgress: (int sent, int total) {
          _streamControllerList[index].sink.add(sent / total);
        },
      );
      _removeFile(file);

      // Navigator.of(context).pop();
      //Navigator.of(context).pop();
      setState(() {
        ///  TODO:用上传图片回调的URL更新图片列表
        widget.list.add(MediaModel.fromJson(response.data));
      });
    } catch (e) {
      print(e);
    }
  }

  //TODO :传入Media参数
  Future _deleteFile(MediaModel mediaModel, {String code}) async {
    if (!widget.loogPressDelete) {
      imagePicker.showDialog(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              '确认删除？',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  '确认',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () async {
                  //TODO :调用删除接口,暂时隐藏
                  // try {
                  //   Response response = await http$.delete(
                  //     Apis.mediaDelete(mediaModel.id),
                  //   );
                  //   if (response != null && response.statusCode == 200) {
                  setState(() {
                    widget.list.remove(mediaModel);
                  });
                  Navigator.pop(context);
                  //   } else {
                  //     print('删除失败');
                  //   }
                  // } catch (e) {
                  //   print(e);
                  // }
                },
              ),
            ],
          );
        },
      );
    }
  }

  int _addFile(File file) {
    setState(() {
      _uploadFileList.add(file);
      _streamControllerList.add(StreamController<double>.broadcast());
    });
    return _uploadFileList.indexOf(file);
  }

  void _removeFile(File file) {
    StreamController streamController =
        _streamControllerList[_uploadFileList.indexOf(file)];
    _streamControllerList.remove(streamController);
    streamController.close();
    setState(() {
      _uploadFileList.remove(file);
    });
  }
}
