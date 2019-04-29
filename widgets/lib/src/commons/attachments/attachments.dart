import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:services/services.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';

///横向滚动图片列表
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

  final StreamController _streamController =
      StreamController<double>.broadcast();

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
          child: _buildAttachmentsListView(widget.width, context),
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

  Widget _buildAttachmentsListView(double width, BuildContext context) {
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
              case 'application/pdf':
                return GestureDetector(
                  child: CommonImage.pdf(),
                  onTap: () {
                    _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
                  },
                );
                break;
              case 'application/msword':
                return GestureDetector(
                  child: CommonImage.word(),
                  onTap: () {
                    _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
                  },
                );
                break;
              case 'application/xlsx':
                return GestureDetector(
                  child: CommonImage.excel(),
                  onTap: () {
                    _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
                  },
                );
                break;
              case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
                return GestureDetector(
                  child: CommonImage.word(),
                  onTap: () {
                    _previewFile(model.actualUrl, 'yijiayi', model.mediaType);
                  },
                );
                break;
              default:
                return GestureDetector(
                  child: Container(
                    width: widget.imageWidth,
                    height: widget.imageHeight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        imageUrl: '${model.previewUrl()}',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            ),
                        errorWidget: (context, url, error) => SpinKitRing(
                              color: Colors.black12,
                              lineWidth: 2,
                              size: 30,
                            )),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                  ),
                  onTap: () {
                    onPreview(context, '${model.detailUrl()}', '${model.name}');
                  },
                );
            }
          },
        ).toList(),
      ),
    );
  }

  //图片预览
  void onPreview(BuildContext context, String url, String name) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          child: Container(
              child: PhotoView(
            imageProvider: NetworkImage(url),
          )),
          onTap: () {
            Navigator.of(context).pop();
          },
        );
      },
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
    //打开文件
    Navigator.of(context).pop();
    OpenFile.open(filePath);
    return filePath;
  }
}

///可编辑（上传、删除）横向滚动图片列表
class EditableAttachments extends StatefulWidget {
  EditableAttachments(
      {Key key,
      @required this.list,
      this.editable = true,
      this.width = 320,
      this.height = 80,
      this.imageWidth = 60,
      this.imageHeight = 60,
      this.maxNum = 5,
      this.uploadURL,
      this.deleteURL})
      : super(key: key);

  final List<MediaModel> list;
  //是否可编辑
  final bool editable;

  final double width;
  final double height;

  ///图片宽度
  final double imageWidth;

  ///图片高度
  final double imageHeight;

  ///凭证最大数
  final int maxNum;

  ///上传URL
  final String uploadURL;

  ///删除URL
  final String deleteURL;

  _EditableAttachmentsState createState() => _EditableAttachmentsState();
}

class _EditableAttachmentsState extends State<EditableAttachments> {
  ScrollController _scrollController = new ScrollController();
  Color iconColorLeft = Colors.grey[200];
  Color iconColorRight = Colors.black;

  final StreamController _streamController =
      StreamController<double>.broadcast();

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
          child: _buildEditableAttachmentsListView(widget.width, context),
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

  Widget _buildEditableAttachmentsListView(double width, BuildContext context) {
    List<Widget> widgetList = [];

    //是否已达限制数量，添加图片按钮
    if (widget.list.length < widget.maxNum) {
      widgetList.add(GestureDetector(
        onTap: () {
          _selectPapersImages();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: widget.imageWidth,
          height: widget.imageHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300], width: 1.0)),
          child: Center(
            child: Icon(
              Icons.add,
              size: widget.imageWidth,
              color: Colors.grey,
            ),
          ),
        ),
      ));
    }

    widgetList.addAll(widget.list.reversed.map(
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
                width: widget.imageWidth,
                height: widget.imageHeight,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: CachedNetworkImage(
                  imageUrl: '${model.previewUrl()}',
                  fit: BoxFit.cover,
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
                onPreview(context, '${model.detailUrl()}', '${model.name}');
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
  void onPreview(BuildContext context, String url, String name) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onLongPress: () async {
            _previewFile(url, name, 'jpeg');
            // downLoadImage(url, name, 'jpeg');
          },
          child: Container(
              child: PhotoView(
            imageProvider: NetworkImage(url),
          )),
        );
      },
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

  void downLoadImage(String url, String name, String mediaType) async {
    var dio = new Dio();

    Response response =
        await dio.get(url, options: Options(responseType: ResponseType.stream));

    HttpClientResponse resp = response.data;

    final Uint8List bytes = await consolidateHttpClientResponseBytes(resp);

    // final result = await ImageGallerySaver.save(bytes);
  }

  void _selectPapersImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('相机'),
              onTap: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  await _uploadFile(image);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('相册'),
              onTap: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await _uploadFile(image);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future _uploadFile(File file) async {
    // TODO： 引入StreamBuilder实时更新进度条
    showDialog(
      context: context,
      barrierDismissible: false,
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
                            '上传中',
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

    // /// TODO: 调用上传接口,更新上传进度条
    try {
      FormData formData = FormData.from({
        "file": UploadFileInfo(file, "file",
            contentType: ContentType.parse('image/jpeg')),
        "conversionGroup": "DefaultProductConversionGroup",
        "imageFormat": "DefaultImageFormat"
      });
      Response<Map<String, dynamic>> response = await http$.post(
        Apis.upload(),
        data: formData,
        // queryParameters: {'conversionGroup': 'DefaultProductConversionGroup'},
        // queryParameters: {'imageFormat': 'DefaultImageFormat'},
        options: Options(
          headers: {'Content-Type': 'application/json;charset=UTF-8'},
        ),
        onSendProgress: (int sent, int total) {
          _streamController.sink.add(sent / total);
        },
      );

      Navigator.of(context).pop();
      Navigator.of(context).pop();
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
