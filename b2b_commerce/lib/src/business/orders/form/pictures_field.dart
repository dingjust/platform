import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PicturesField extends StatefulWidget {
  RequirementOrderModel model;
  ApparelProductModel product;
  bool enabled;

  PicturesField({this.model, this.product, this.enabled = true});

  PicturesFieldState createState() => PicturesFieldState();
}

class PicturesFieldState extends State<PicturesField> {
  @override
  void initState() {
    if (widget.model.details.pictures == null) {
      widget.model.details.pictures = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
          child: Row(
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: '添加图片',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: '（补充图片可令工厂更快了解需求）',
                    style: TextStyle(fontSize: 16, color: Colors.orange[800]),
                  ),
                ]),
              ),
            ],
          ),
        ),
//        PhotoPicker(images: widget.normalImages, width: 350),
        EditableAttachments(
          list: widget.model.details.pictures,
          // maxNum:
          //     widget.product == null ? 5 : widget.model.details.pictures.length,
          // maxNum: ,
          editable: widget.product == null && widget.enabled,
        )
      ],
    );
  }
}
