import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AlbumsAndCameras extends StatefulWidget {
  List<String> pictureUrls;
  List<File> images;
  double height;
  double width;
  double iconSize;
  int count;

  AlbumsAndCameras(
      {this.images, this.height, this.width, this.iconSize, this.count,this.pictureUrls});

  AlbumsAndCamerasState createState() => AlbumsAndCamerasState();
}

class AlbumsAndCamerasState extends State<AlbumsAndCameras> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
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
              children: _papersWidgetList,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> get _papersWidgetList {
    List<Widget> list = <Widget>[];
    List<Widget> images = widget.images
        .map((file) => Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(file),
                  fit: BoxFit.cover,
                ),
              ),
            ))
        .toList();

    if(widget.pictureUrls != null){
      List<Widget> pictures = widget.pictureUrls.map((url){
        return Image.network(url,width: widget.width,height: widget.height,fit: BoxFit.fill,);
      }).toList();
      list.addAll(pictures);
    }

    list.addAll(images);

    if (list.length < widget.count) {
      list.add(Container(
        child: IconButton(
          onPressed: selectPapersImages,
          icon: Icon(Icons.add_photo_alternate),
          iconSize: widget.iconSize,
          color: Colors.grey[500],
        ),
      ));
    }
    return list;
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
                    widget.images.add(image);
                    Navigator.pop(context);
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
                    widget.images.add(image);
                    Navigator.pop(context);
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
