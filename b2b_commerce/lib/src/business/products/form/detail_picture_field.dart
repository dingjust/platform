import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 主图
class DetailPictureField extends StatefulWidget {
  DetailPictureField(this.item,{this.enabled = false});

  final ApparelProductModel item;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _DetailPictureFieldState();
}

class _DetailPictureFieldState extends State<DetailPictureField> {
  @override
  void initState() {
    if(widget.item.details == null) widget.item.details = [];

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
              Text(
                '上传详情图',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '（最多5张）',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            ],
          ),
        ),
        EditableAttachments(list: widget.item.details,editable: widget.enabled,)
      ],
    );
  }

}
