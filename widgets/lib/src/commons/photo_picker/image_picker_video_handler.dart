import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'image_picker_video_dialog.dart';

class ImagePickerVideoHandler {
  ImagePickerVideoDialog imagePicker;
  AnimationController _controller;
  ImagePickerVideoListener _listener;

  ImagePickerVideoHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickVideo(source: ImageSource.camera);
    _listener.useVideo(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    _listener.useVideo(image);
  }

  void build(int bgColor, int labelColor) {
    imagePicker =
        new ImagePickerVideoDialog(this, _controller, bgColor, labelColor);
    imagePicker.initState();
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerVideoListener {
  useVideo(File _video);
}
