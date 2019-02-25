import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPicker extends StatefulWidget {
  ///图片文件列表
  List<File> images;

  ///组件宽
  final double width;

  ///组件高
  final double height;

  ///图片宽度
  final double imageWidth;

  // ///图片高度
  // final double imageHeight;

  ///凭证最大数
  final int maxNum;

  PhotoPicker(
      {Key key,
      @required this.images,
      this.width = 350,
      this.height = 80,
      this.imageWidth = 80,
      this.maxNum = 5})
      : super(key: key);

  _PhotoPickerState createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    //未达限制数量，添加图片按钮
    if (widget.images.length < widget.maxNum) {
      widgetList.add(GestureDetector(
        onTap: () {
          _selectPapersImages();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: widget.imageWidth,
          height: widget.height,
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10),
            color: Color.fromRGBO(242, 242, 242, 1),
            // border: Border.all(color: Colors.grey[300], width: 1.0)
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: widget.imageWidth * 0.6,
              color: Colors.grey,
            ),
          ),
        ),
      ));
    }

    if (widget.images.isNotEmpty) {
      widgetList.addAll(widget.images.reversed
          .map((file) => GestureDetector(
                child: Container(
                  width: widget.imageWidth,
                  height: widget.height,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  onPreview(context, file);
                },
                onLongPress: () {
                  _deleteFile(file);
                },
              ))
          .toList());
    }

    return Container(
      width: widget.width,
      height: widget.height,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widgetList,
      ),
    );
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
                  _addFile(image);
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
                  _addFile(image);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addFile(File file) {
    //关闭弹框
    Navigator.pop(context);
    setState(() {
      widget.images.add(file);
    });
  }

  void _deleteFile(File file) {
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
              onPressed: () {
                //TODO :调用删除接口
                setState(() {
                  widget.images.remove(file);
                });
                Navigator.pop(context);
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

  //图片预览
  void onPreview(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
            child: PhotoView(
          imageProvider: FileImage(file),
        ));
      },
    );
  }
}
