import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http_parser/http_parser.dart';
import 'package:models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';
import 'package:widgets/src/commons/gallery/gallery_item.dart';
import 'package:widgets/src/commons/gallery/gallery_photo_view_wrapper.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';
import 'package:widgets/src/commons/photo_picker/image_picker_handler.dart';

import '../../../widgets.dart';

///可编辑（上传、删除）横向滚动图片列表
class EditableAttachmentsV2 extends StatefulWidget {
  EditableAttachmentsV2({
    Key key,
    @required this.list,
    this.editable = true,
    this.maxNum = 9,
    this.uploadURL,
    this.deleteURL,
    this.loogPressDelete = true,
    this.rowNum = 3,
    this.padding = 12,
  }) : super(key: key);

  final List<MediaModel> list;

  //是否可编辑
  final bool editable;

  ///凭证最大数
  final int maxNum;

  ///上传URL
  final String uploadURL;

  ///删除URL
  final String deleteURL;

  //是否长按删除
  final bool loogPressDelete;

  final int rowNum;

  final double padding;

  _EditableAttachmentsV2State createState() => _EditableAttachmentsV2State();
}

class _EditableAttachmentsV2State extends State<EditableAttachmentsV2>
    with TickerProviderStateMixin, ImagePickerListener {
  final StreamController _streamController =
      StreamController<double>.broadcast();

  final StreamController _compressStreamController =
      StreamController<double>.broadcast();

  //stream列
  // List<StreamController> _streamControllerList = [];
  // Map<String, StreamController> _streamControllerMap = {};
  // Map<String, File> _fileMap = {};
  List<File> _uploadFileList = [];
  List<StreamController> _streamControllerList = [];

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker =
        new ImagePickerHandler(this, _controller, maxNum: widget.maxNum);
    imagePicker.build(0xFFFFFFFF, 0xFF6495ED, false, 0, 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamController.close();
    _compressStreamController.close();
    super.dispose();
  }

  @override
  userImage(File _image) async {
    if (widget.maxNum == 1) {
      widget.list.clear();
    }
    if (_image != null) {
      await _uploadFile(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double size = (constraints.maxWidth -
                      (widget.rowNum - 1) * widget.padding) /
                  widget.rowNum;
              return widget.maxNum == 1
                  ? _buildEditableAttachment(size)
                  : _buildEditableAttachmentsV2ListView(context, size);
            },
          ),
        )
      ],
    ));
  }

  Widget _buildEditableAttachment(double size) {
    if (_uploadFileList.length > 0) {
      return GestureDetector(
        child: Container(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(
                _uploadFileList[0],
              ),
              Container(
                width: size,
                height: size,
                color: Colors.black26,
              ),
              StreamBuilder<double>(
                  stream: _streamControllerList[0].stream,
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
      );
    } else if (widget.list.length > 0) {
      return GestureDetector(
        child: Container(
          width: size,
          height: size,
          child: CachedNetworkImage(
            imageUrl: '${widget.list[0].previewUrl()}',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            ),
            placeholder: (context, url) => SpinKitRing(
              color: Colors.black12,
              lineWidth: 2,
              size: 30,
            ),
            errorWidget: (context, url, error) => SpinKitRing(
              color: Colors.black12,
              lineWidth: 2,
              size: 30,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey,
          ),
        ),
        onTap: () {
          // onPreview(context, '${model.detailUrl()}', '${model.name}');
          onPreview(context, widget.list[0]);
        },
        onLongPress: () {
          if (widget.editable) _deleteFile(widget.list[0]);
        },
      );
    } else {
      return GestureDetector(
        onTap: () {
          imagePicker.showDialog(context);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300], width: 1.0)),
          child: Center(
            child: Icon(
              Icons.add,
              size: size,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildEditableAttachmentsV2ListView(
      BuildContext context, double size) {
    List<Widget> widgetList = [];

    widgetList.addAll(widget.list.map(
      (model) {
        // 附件类型
        switch (model.mediaType) {
          case 'application/pdf':
            return GestureDetector(
              child: CommonImage.pdf(),
              onTap: () {
                _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
              },
              onLongPress: () {
                _deleteFile(model);
              },
            );
            break;
          case 'application/msword':
            return GestureDetector(
              child: CommonImage.word(),
              onTap: () {
                _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
              },
              onLongPress: () {
                _deleteFile(model);
              },
            );
            break;
          case 'application/xlsx':
            return GestureDetector(
              child: CommonImage.excel(),
              onTap: () {
                _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
              },
              onLongPress: () {
                _deleteFile(model);
              },
            );
            break;
          default:
            return GestureDetector(
              child: Container(
                width: size,
                height: size,
                child: CachedNetworkImage(
                  imageUrl: '${model.previewUrl()}',
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      color: Color(0xFFE7E7E7),
                    ),
                  ),
                  placeholder: (context, url) => SpinKitRing(
                    color: Colors.black12,
                    lineWidth: 2,
                    size: size * 2 / 3,
                  ),
                  errorWidget: (context, url, error) => SpinKitRing(
                    color: Colors.black12,
                    lineWidth: 2,
                    size: size * 2 / 3,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFE7E7E7),
                ),
              ),
              onTap: () {
                onPreview(context, model);
              },
              onLongPress: () {
                if (widget.editable) _deleteFile(model);
              },
            );
        }
      },
    ).toList());

    //上传中的图片
    for (int i = 0; i < _uploadFileList.length; i++) {
      widgetList.add(GestureDetector(
        child: Container(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.file(
                _uploadFileList[i],
              ),
              Container(
                width: size,
                height: size,
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

    //是否已达限制数量，添加图片按钮
    if (widget.list.length < widget.maxNum && widget.editable) {
      widgetList.add(GestureDetector(
        onTap: () {
          imagePicker.showDialog(context);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Color(0xFFF0F0F0),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: size * 2 / 3,
              color: Color(0xFF999999),
            ),
          ),
        ),
      ));
    }

    return Container(
      child: Wrap(
        spacing: widget.padding, // 主轴(水平)方向间距
        runSpacing: widget.padding, //
        children: widgetList,
      ),
    );
  }

  //图片预览
  void onPreview(BuildContext context, MediaModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context1) => GalleryPhotoViewWrapper(
          galleryItems:
              widget.list.map((model) => GalleryItem(model: model)).toList(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: widget.list.indexOf(model),
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  //文件下载打开
  Future<String> _previewFile(String url, String name, String mediaType) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            StreamBuilder<double>(
                stream: _streamController.stream,
                initialData: 0.0,
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '下载中',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Center(
                          child: LinearProgressIndicator(
                            value: snapshot.data,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('进度:', style: TextStyle(fontSize: 12)),
                            Text('${((snapshot.data / 1) * 100).round()}%',
                                style: TextStyle(fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  );
                })
          ],
        );
      },
    );

    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/$name.${FileFormatUtil.mediaFormat(mediaType)}";
    var dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };
    try {
      Response response = await dio.download(url, filePath,
          onReceiveProgress: (received, total) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        _streamController.sink.add(received / total);
      });
      print(response.statusCode);
    } catch (e) {
      print(e);
    }

    Navigator.of(context).pop();
    //打开文件
    OpenFile.open(filePath);
    print('${filePath}');

    return filePath;
  }

  Future _uploadFile(File sourceFile) async {
    //上传文件置入列表
    int index = _addFile(sourceFile);
    //调用上传接口,更新上传进度条
    try {
      //调用插件压缩图片
      Uint8List file = await FlutterImageCompress.compressWithFile(
        sourceFile.absolute.path,
        minWidth: 1920,
        minHeight: 1080,
        quality: 90,
      );

      MultipartFile multipartFile = await MultipartFile.fromBytes(file,
          filename: "file", contentType: MediaType.parse('image/jpeg'));

      FormData formData = FormData.fromMap({
        // "file": UploadFileInfo(file, "file",
        //     contentType: ContentType.parse('image/jpeg')),
        // "file": await MultipartFile.fromFile(file.path,
        //     filename: "file", contentType: MediaType.parse('image/jpeg')),
        "file": multipartFile,
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
      _removeFile(sourceFile);

      setState(() {
        ///  TODO:用上传图片回调的URL更新图片列表
        widget.list.add(MediaModel.fromJson(response.data));
      });
    } catch (e) {
      _removeFile(sourceFile);
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
