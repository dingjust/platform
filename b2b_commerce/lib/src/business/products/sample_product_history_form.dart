import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import 'sample_products.dart';

class SampleProductHistoryFormPage extends StatefulWidget {
  SampleProductHistoryFormPageState createState() =>
      SampleProductHistoryFormPageState();
}

class SampleProductHistoryFormPageState
    extends State<SampleProductHistoryFormPage> {
  LendBorrowType _type = LendBorrowType.BORROW;
  List<File> _normalImages = [];
  FocusNode _nameFocusNode = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  FocusNode _skuIDFocusNode = FocusNode();
  final TextEditingController _skuIDController = TextEditingController();
  FocusNode _quantityFocusNode = FocusNode();
  final TextEditingController _quantityController = TextEditingController();
  FocusNode _remakeFocusNode = FocusNode();
  final TextEditingController _remakeController = TextEditingController();
  FocusNode _relatedPartyFocusNode = FocusNode();
  final TextEditingController _relatedPartyController = TextEditingController();
  FocusNode _contactWayFocusNode = FocusNode();
  final TextEditingController _contactWayController = TextEditingController();

  Text _nameText = Text('点击选择', style: TextStyle(color: Colors.grey));
  String _skuIDText = '';
  Text _expectedReturnDateText = Text(
    '点击选择日期',
    style: TextStyle(color: Colors.grey),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('新建记录'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ActionChip(
                shape: StadiumBorder(
                    side: BorderSide(
                        color: _type == LendBorrowType.BORROW
                            ? Color.fromRGBO(255,214,12, 1)
                            : Colors.white)),
                labelPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                backgroundColor: Colors.white,
                label: Text('借出'),
                labelStyle: TextStyle(
                    color: _type == LendBorrowType.BORROW
                        ? Color.fromRGBO(255,214,12, 1)
                        : Colors.black),
                onPressed: () {
                  setState(() {
                    _type = LendBorrowType.BORROW;
                  });
                },
              ),
              ActionChip(
                shape: StadiumBorder(
                    side: BorderSide(
                        color: _type == LendBorrowType.LEND
                            ? Color.fromRGBO(255,214,12, 1)
                            : Colors.white)),
                labelPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                backgroundColor: Colors.white,
                label: Text('借入'),
                labelStyle: TextStyle(
                    color: _type == LendBorrowType.LEND
                        ? Color.fromRGBO(255,214,12, 1)
                        : Colors.black),
                onPressed: () {
                  setState(() {
                    _type = LendBorrowType.LEND;
                  });
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      '样衣图片',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '（若无图片可不上传）',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    )
                  ],
                ),
              ),
              PhotoPicker(
                images: _normalImages,
                maxNum: 10,
                width: 400,
              ),
            ],
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: <Widget>[
                  _type == LendBorrowType.BORROW
                      ? Column(
                          children: <Widget>[
                            ListTile(
                              leading: Text(
                                '样衣名称',
                                style: TextStyle(fontSize: 16),
                              ),
                              title: Container(
                                padding: EdgeInsets.only(left: 28),
                                child: GestureDetector(
                                  child: _nameText,
                                  onTap: () async {
                                    SampleProductModel model =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SampleProductsPage(
                                                        isHistoryCreate:
                                                            true)));
                                    _nameText = Text(model.name,
                                        style: TextStyle(color: Colors.black));
                                    _skuIDText = model.skuID;
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(
                                height: 0,
                                color: Colors.grey[400],
                              ),
                            ),
                            ListTile(
                              leading: Text(
                                '货号',
                                style: TextStyle(fontSize: 16),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 60),
                                child: Text(_skuIDText),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Divider(
                                height: 0,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            TextFieldComponent(
                              focusNode: _nameFocusNode,
                              controller: _nameController,
                              leadingText: '样衣名称',
                              hintText: '请输入样衣名称',
                              leadingWidth: 100,
                            ),
                            TextFieldComponent(
                              focusNode: _skuIDFocusNode,
                              controller: _skuIDController,
                              leadingText: '货号',
                              hintText: '请输入货号',
                              leadingWidth: 100,
                            ),
                          ],
                        ),
                  TextFieldComponent(
                    focusNode: _quantityFocusNode,
                    controller: _quantityController,
                    leadingText:
                        _type == LendBorrowType.BORROW ? '借出数量' : '借入数量',
                    hintText:
                        _type == LendBorrowType.BORROW ? '请输入借出数量' : '请输入借入数量',
                    leadingWidth: 100,
                  ),
                  ListTile(
                    leading: Text(
                      '预计归还时间',
                      style: TextStyle(fontSize: 16),
                    ),
                    title: Container(
//                      padding: EdgeInsets.only(left: 18),
                      child: GestureDetector(
                        child: _expectedReturnDateText,
                        onTap: () {
                          _selectDate(context).then((value) {
                            setState(() {
                              if (value != null) {
                                _expectedReturnDateText =
                                    Text(DateFormatUtil.formatYMD(value));
                              } else {
                                _expectedReturnDateText = Text(
                                  '点击选择日期',
                                  style: TextStyle(color: Colors.grey),
                                );
                              }
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      height: 0,
                      color: Colors.grey[400],
                    ),
                  ),
                  TextFieldComponent(
                    focusNode: _remakeFocusNode,
                    controller: _remakeController,
                    leadingText: '备注',
                    hintText: '请输入备注',
                    leadingWidth: 100,
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: <Widget>[
                  TextFieldComponent(
                    focusNode: _relatedPartyFocusNode,
                    controller: _relatedPartyController,
                    leadingText: '关联方',
                    hintText:
                        _type == LendBorrowType.BORROW ? '我借给谁的' : '谁借给我的',
                    leadingWidth: 100,
                  ),
                  TextFieldComponent(
                    focusNode: _contactWayFocusNode,
                    controller: _contactWayController,
                    leadingText: '联系方式',
                    hintText: '请输入联系方式',
                    leadingWidth: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
  }
}
