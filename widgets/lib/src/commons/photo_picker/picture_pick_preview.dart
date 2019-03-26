import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PicturePickPreviewWidget extends StatefulWidget {
  List<MediaModel> medias;

  //标题字体样式
  final TextStyle titleFont;

  //副标题字体样式
  final TextStyle subtitleFont;

  ///组件高度
  final double height;

  ///子项宽度
  final double itemWidth;

  //组件是否滚动
  final bool primary;

  PicturePickPreviewWidget({
    this.medias,
    this.subtitleFont,
    this.titleFont,
    this.height = 300,
    this.itemWidth = 240.0,
    this.primary = false,
  });

  _PicturePickPreviewWidget createState() => _PicturePickPreviewWidget();
}

class _PicturePickPreviewWidget extends State<PicturePickPreviewWidget> {
  ScrollController _scrollController = new ScrollController();
  Color iconColorLeft = Colors.grey[200];
  Color iconColorRight = Colors.black;
  String userType;

  final StreamController _streamController = StreamController<double>.broadcast();

  List<MediaModel> mediaList;
  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      userType = 'brand';
    }else{
      userType = 'factory';
      MediaModel model = new MediaModel();
      widget.medias.insert(0, model);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.keyboard_arrow_left),
              onPressed: () {
                if (userType == 'factory') {
                  //带参数返回
                  widget.medias.removeAt(0);
                  Navigator.of(context).pop(widget.medias);
                } else {
                  Navigator.of(context).pop();
                }
              }
          ),
          title: Text(' '),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,

        ),
        body: Container(
            child:
            _buildGrid(context)
        ),
      ),
      onWillPop: () {
        if (userType == 'factory') {
          //带参数返回
          widget.medias.removeAt(0);
          Navigator.of(context).pop(widget.medias);
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView(
      physics:
      widget.primary == false ? NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: widget.itemWidth,
          crossAxisSpacing: 10),
      children: List.generate(widget.medias.length, (index) {
        if (index == 0 && userType == 'factory') {
          return GestureDetector(
              child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 3.0),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.grey,
                        size: 100,
                      ),
                    ),
                  )),
              onTap: () {
                _selectPapersImages();
              });
        }
        return GestureDetector(
          child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 3.0),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 5, 15, 5),
                child: Center(
                  child: Image.network(
                    '${GlobalConfigs.IMAGE_BASIC_URL}${widget.medias[index].url}',
                    width: 500,
                    height: 500,
                  ),
                ),
              )
          ),
          onTap: () {
            onPreview(
                context,'${GlobalConfigs.IMAGE_BASIC_URL}${widget.medias[index].url}');
          },
          onLongPress: () {
            _deleteFile(widget.medias[index]);
          },
        );
      }),
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
  Future<String> _previewFile(String url, String name, String mediaType) async {
    String downloadUrl = '${GlobalConfigs.IMAGE_BASIC_URL}${url}';
    showDialog(
      context: context,
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

    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    String filePath = "$dir/$name.${FileFormatUtil.mediaFormat(mediaType)}";
    var dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };
    try {
      Response response = await dio.download(downloadUrl, filePath,
          onReceiveProgress: (received, total) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            _streamController.sink.add(received / total);
          });
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
    //打开文件
    OpenFile.open(filePath);
    return filePath;
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

    try {
      FormData formData = FormData.from({"file": UploadFileInfo(file, "file")});
      Response<Map<String, dynamic>> response = await http$.post(
        Apis.upload(),
        data: formData,
        queryParameters: {'conversionGroup': 'DefaultProductConversionGroup'},
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
        onSendProgress: (int sent, int total) {
          _streamController.sink.add(sent / total);
        },
      );

      Navigator.of(context).pop();
      Navigator.of(context).pop();
      //写入具体url
      String baseUrl = response.data['url'];
      String url = '${GlobalConfigs.IMAGE_BASIC_URL}$baseUrl';
      response.data['url'] = url;
      setState(() {
        widget.medias.add(MediaModel.fromJson(response.data));
      });
    } catch (e) {
      print(e);
    }
  }

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
              child: Text('确认'),
              onPressed: () async {
                //TODO :调用删除接口,暂时隐藏
                // try {
                //   Response response = await http$.delete(
                //     Apis.mediaDelete(mediaModel.id),
                //   );
                //   if (response != null && response.statusCode == 200) {
                setState(() {
                  widget.medias.remove(mediaModel);
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
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

}
