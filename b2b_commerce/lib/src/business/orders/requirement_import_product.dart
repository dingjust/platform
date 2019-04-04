import 'dart:io';

import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

import 'package:b2b_commerce/src/_shared/products/product_search_input.dart';

List<File> _BOMList = [];

class RequirementImportProduct extends StatefulWidget {
  _RequirementImportProductState createState() => _RequirementImportProductState();
}

class _RequirementImportProductState extends State<RequirementImportProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我的商品'),
          elevation: 0.5,
          brightness: Brightness.light,
          centerTitle: true,
          actions: <Widget>[
            GestureDetector(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Center(
                    child: Text(
                      '确定',
                      style: TextStyle(color: Color.fromRGBO(255, 149, 22, 1)),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                })
          ],
        ),
        body: Container(
            child: ListView(
          children: <Widget>[
            _buildFindProduct(context),
            _buildBOM(context),
          ],
        )));
  }

  Widget _buildFindProduct(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 270,
      child: Column(
        children: <Widget>[
          _buildTips(context, '按照现有商品生产'),
          _buildSearch(context),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildTips(BuildContext context, String tips) {
    return Center(
      child: Text(
        tips,
        style: TextStyle(fontSize: 14, color: Colors.black26),
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          ProductSearchInput(
            width: 300,
            tips: '请输入商品名或货号',
          ),
          Expanded(
              child: Container(
            width: 30,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: RaisedButton(
                color: Color(0xFFFF9516),
                child: Text(
                  '查询',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                onPressed: () {}),
          ))
        ],
      ),
    );
  }

  Widget _buildBOM(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 200,
      child: Column(
        children: <Widget>[
          _buildTips(context, 'BOM表'),
          _buildBOMPicker(context),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildBOMPicker(BuildContext context) {
    return Container(
      child: PhotoPicker(
        images: _BOMList,
        maxNum: 10,
        width: 400,
      ),
    );
  }
}
