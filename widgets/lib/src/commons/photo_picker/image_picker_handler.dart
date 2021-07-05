import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;

  final int maxNum;

  ImagePickerHandler(this._listener, this._controller, {this.maxNum = 1});

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _listener.userImage(image);
  }

  openGallery(BuildContext context) async {
    if (maxNum == 1) {
      imagePicker.dismissDialog();
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      _listener.userImage(image);
    } else {
      openMultiGallery(context);
    }
  }

  ///多选
  openMultiGallery(BuildContext context) async {
    final List<AssetEntity> assets = await AssetPicker.pickAssets(context);
    if (assets != null) {
      assets.forEach((element) {
        element.file.then((value) => _listener.userImage(value));
      });
    }
    imagePicker.dismissDialog();
  }

  void build(int bgColor, int labelColor, bool isCropRequired, double ratioX,
      double ratioY) {
    imagePicker = new ImagePickerDialog(this, _controller, bgColor, labelColor);
    imagePicker.initState();
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
