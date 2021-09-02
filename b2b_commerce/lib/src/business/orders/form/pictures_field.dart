import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class PicturesField extends StatefulWidget {
  RequirementOrderModel model;
  ApparelProductModel product;
  bool enabled;

  final String description;

  PicturesField(
      {this.model, this.product, this.enabled = true, this.description = ''});

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
    return EditableAttachmentsV2(
      list: widget.model.details.pictures,
      // maxNum:
      //     widget.product == null ? 5 : widget.model.details.pictures.length,
      // maxNum: ,
      editable: widget.product == null && widget.enabled,
    );
  }
}
