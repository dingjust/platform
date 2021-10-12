import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:widgets/src/helper/permission_helper.dart';

import 'image_picker_handler.dart';

class ImagePickerDialog extends StatelessWidget {
  ImagePickerHandler _listener;
  AnimationController _controller;
  BuildContext context;
  int bgColor;
  int labelColor;

  ImagePickerDialog(
      this._listener, this._controller, this.bgColor, this.labelColor);

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    _drawerContentsOpacity = new CurvedAnimation(
      parent: new ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = new Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(new CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (_controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    _controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) => new SlideTransition(
        position: _drawerDetailsPosition,
        child: new FadeTransition(
          opacity: new ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    _controller.dispose();
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 200);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    _controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Material(
        type: MaterialType.transparency,
        child: new Opacity(
          opacity: 1.0,
          child: new Container(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new InkWell(
                  // onTap: () => _listener.openCamera(),
                  onTap: () async {
                    PermissionHelper.check(Permission.camera).then((value) {
                      if (value) {
                        _listener.openCamera();
                      }
                    });
                  },
                  child: roundedButton(
                    "拍一张",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    new Color(bgColor),
                    new Color(labelColor),
                    BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                ),
                Divider(
                  height: 0,
                ),
                new GestureDetector(
                  onTap: () async {
                    // Permission permission;
                    // if (defaultTargetPlatform == TargetPlatform.android) {
                    //   permission = Permission.storage;
                    // }else{
                    //   permission
                    // }
                    // _listener.openGallery(context);
                    // print(object)
                    Permission.photos.status.then((value) {
                      print('photos: $value');
                    });
                    Permission.mediaLibrary.status.then((value) {
                      print('mediaLibrary: $value');
                    });
                    Permission.storage.status.then((value) {
                      print('storage: $value');
                    });
                    _listener.openGallery(context);
                  },
                  child: roundedButton(
                    "从相册选择",
                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    new Color(bgColor),
                    new Color(labelColor),
                    BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                ),
//                const SizedBox(height: 15.0),
                new GestureDetector(
                  onTap: () => dismissDialog(),
                  child: roundedButton(
                    "取消",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    new Color(bgColor),
                    new Color(labelColor),
                    BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget roundedButton(String buttonLabel, EdgeInsets margin, Color bgColor,
      Color textColor, BorderRadius borderRadius) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(color: textColor, fontSize: 20.0),
      ),
    );
    return loginBtn;
  }
}
