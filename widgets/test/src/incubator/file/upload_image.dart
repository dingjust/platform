import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _headImage;
  List<File> _papersImages = [];

  _commitForm() {
    Dio dio = Dio();

    //上次多张图片
    List<UploadFileInfo> uploadFiles = <UploadFileInfo>[];

    for (File file in _papersImages) {
      uploadFiles.add(UploadFileInfo(file, file.absolute.path));
    }

    FormData formData = FormData.from({
      'id': 8796093075377,
      'files': uploadFiles,
    });

    //上传单张图片
    /*   FormData formData = FormData.from({
      'id': 8796093075377,
      'files': UploadFileInfo(_headImage, _headImage.absolute.path),
    });*/

    dio.post(
        'http://192.168.31.58:9001/djbackoffice/system/carousel/updateMedia',
        data: formData);
  }

  List<Widget> get _papersWidgetList {
    List<Widget> list = _papersImages
        .map((file) => Container(
              width: 60.0,
              height: 60.0,
              child: Image.file(file),
            ))
        .toList();
    list.add(Container(
      child: IconButton(
        onPressed: selectPapersImages,
        icon: Icon(Icons.add_photo_alternate),
        iconSize: 60.0,
        color: Colors.grey[500],
      ),
    ));

    return list;
  }

  /* _papersWidgetList.add(Container(
  child: IconButton(
  onPressed: selectImageSource,
  icon: Icon(Icons.add_photo_alternate),
  iconSize: 60.0,
  color: Colors.grey[500],
  ),
  ));*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              tooltip: '确定',
              onPressed: _commitForm,
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: Form(
          autovalidate: true,
          child: ListView(
            padding: EdgeInsets.fromLTRB(0, 10.0, 0, 20.0),
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 20),
                  child: Column(
                    children: <Widget>[
                      Text(
                        '基本信息',
                        style: TextStyle(fontSize: 18.0),
                      )
                    ],
                  )),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('上传头像'),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 10, 10.0, 10.0),
                                width: 70.0,
                                height: 70.0,
                                child: _headImage == null
                                    ? IconButton(
                                        onPressed: selectHeadImage,
                                        icon: Icon(Icons.add_photo_alternate),
                                        iconSize: 60.0,
                                        color: Colors.grey[500],
                                      )
                                    : GestureDetector(
                                        onTap: selectHeadImage,
                                        child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: FileImage(_headImage),
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: _papersWidgetList),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void selectHeadImage() async {
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
                setState(() {
                  _headImage = image;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('相册'),
              onTap: () async {
                var image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _headImage = image;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void selectPapersImages() async {
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
                  setState(() {
                    _papersImages.add(image);
                  });
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
                  setState(() {
                    _papersImages.add(image);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
