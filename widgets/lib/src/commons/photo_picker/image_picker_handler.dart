import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  bool _isCropRequired;
  double _ratioX;
  double _ratioY;

  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_isCropRequired) {
      cropImage(image);
    } else {
      _listener.userImage(image);
    }
  }

  openGallery() async {
    imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_isCropRequired) {
      cropImage(image);
    } else {
      _listener.userImage(image);
    }
  }

  void build(int bgColor, int labelColor, bool isCropRequired, double ratioX,
      double ratioY) {
    _isCropRequired = isCropRequired;
    _ratioX = ratioX;
    _ratioY = ratioY;
    imagePicker = new ImagePickerDialog(this, _controller, bgColor, labelColor);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: _ratioX, ratioY: _ratioY)
//      maxWidth: 512,
//      maxHeight: 512,
    );
    _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    print('${imagePicker}================');
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}
