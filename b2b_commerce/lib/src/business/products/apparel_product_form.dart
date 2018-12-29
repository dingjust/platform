import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductFormPage extends StatelessWidget {
  ApparelProductFormPage({this.item});

  final ApparelProductModel item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('创建/更新商品'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Text('商品表单'),
      ),
    );
  }
}
