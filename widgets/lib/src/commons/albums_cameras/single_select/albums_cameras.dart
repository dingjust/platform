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
      {this.images, this.height = 100, this.width = 100, this.iconSize = 100, this.count = 5,this.pictureUrls});

  AlbumsAndCamerasState createState() => AlbumsAndCamerasState();
}

class AlbumsAndCamerasState extends State<AlbumsAndCameras> {
  List<Widget> _list = <Widget>[];

  @override
  void initState() {
    if(widget.pictureUrls != null){
      List<Widget> pictures = widget.pictureUrls.map((url){
        return Image.network(url,width: widget.width,height: widget.height,fit: BoxFit.fill,);
      }).toList();
      _list.addAll(pictures);
    }

    if (_list.length < widget.count) {
      _list.add(Container(
        child: IconButton(
          onPressed: selectPapersImages,
          icon: Icon(Icons.add_photo_alternate),
          iconSize: widget.iconSize,
          color: Colors.grey[500],
        ),
      ));
    }

    // TODO: implement initState
    super.initState();
  }

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
              children: _list,
            ),
          )
        ],
      ),
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
                    widget.images.add(image);
                    _list.removeLast();

                    _list.add(Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ));

                    if (_list.length < widget.count) {
                      _list.add(Container(
                        child: IconButton(
                          onPressed: selectPapersImages,
                          icon: Icon(Icons.add_photo_alternate),
                          iconSize: widget.iconSize,
                          color: Colors.grey[500],
                        ),
                      ));
                    }
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

                    _list.removeLast();

                    _list.add(Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ));

                    if (_list.length < widget.count) {
                      _list.add(Container(
                        child: IconButton(
                          onPressed: selectPapersImages,
                          icon: Icon(Icons.add_photo_alternate),
                          iconSize: widget.iconSize,
                          color: Colors.grey[500],
                        ),
                      ));
                    }
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
