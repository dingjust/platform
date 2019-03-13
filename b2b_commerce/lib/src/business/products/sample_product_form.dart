import 'dart:io';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SampleProductFormPage extends StatefulWidget {
  SampleProductModel item;
  SampleProductFormPage({this.item});

  SampleProductFormPageState createState() => SampleProductFormPageState();
}

class SampleProductFormPageState extends State<SampleProductFormPage>{
  List<File> _images = [];
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  FocusNode _skuIDFocusNode = FocusNode();
  TextEditingController _skuIDController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.item?.name;
    _skuIDController.text = widget.item?.skuID;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('编辑样衣'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:15.0,top: 10),
            child: Text('上传样衣图片'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: PhotoPicker(images: _images,),
          ),
          TextFieldComponent(
            focusNode: _nameFocusNode,
            controller: _nameController,
            leadingText: '样衣名称',
            hintText: '请输入样衣名称',
          ),
          TextFieldComponent(
            focusNode: _skuIDFocusNode,
            controller: _skuIDController,
            leadingText: '货号',
            hintText: '请输入样衣名称',
          ),
          Expanded(child: ListTile(title:  RaisedButton(onPressed: (){Navigator.pop(context);},child: Text('确认'),color: Color.fromRGBO(255,214,12, 1),),)),
        ],
      ),
    );
  }
}