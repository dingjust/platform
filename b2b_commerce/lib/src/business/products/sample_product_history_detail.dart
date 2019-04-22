import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'sample_products.dart';

class SampleProductHistoryFormPage extends StatefulWidget {
  SampleBorrowReturnHistoryModel model;

  SampleProductHistoryFormPage(this.model);

  SampleProductHistoryFormPageState createState() =>
      SampleProductHistoryFormPageState();
}

class SampleProductHistoryFormPageState
    extends State<SampleProductHistoryFormPage> {
  SampleProductModel _sampleProduct;
  LendBorrowType _type = LendBorrowType.BORROW;
  List<MediaModel> _pictures = [];
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

  Text _nameText =
  Text('点击选择', style: TextStyle(color: Colors.grey[400], fontSize: 17));
  String _skuIDText = '';
  Text _expectedReturnDateText = Text(
    '点击选择日期',
    style: TextStyle(color: Colors.grey[400], fontSize: 17),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('新建记录'),
        actions: <Widget>[
          IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () async{
                if(_type == LendBorrowType.BORROW){
                  if(_sampleProduct == null){
                    showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                          content: Text('样衣不能为空'),
                        ));
                    return;
                  }else{
                    widget.model.name = _sampleProduct.name;
                    widget.model.code = _sampleProduct.code;
                    widget.model.images = _sampleProduct.pictures;
                  }
                }else{
                  if (_nameController.text == '' && _skuIDController.text == '') {
                    showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                          content: Text('样衣名称和货号不能为空'),
                        ));
                    return;
                  }else{
                    widget.model.name =_nameController.text;
                    widget.model.code =_skuIDController.text;
                  }
                }

                widget.model.state = ReturnState.NOT_RETURNED;
                widget.model.type = _type;
                widget.model.quantity = _quantityController.text == '' ? 0 : int.parse(_quantityController.text);
                widget.model.contact = _contactWayController.text == ''
                    ? null
                    : _contactWayController.text;
                widget.model.remarks = _remakeController.text == ''
                    ? null
                    : _remakeController.text;
                widget.model.relatedParty = _relatedPartyController.text == ''
                    ? null
                    : _relatedPartyController.text;


                String code = await ProductRepositoryImpl().createSampleHistory(widget.model);

//                Navigator.pop(context);
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
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.white)),
                labelPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                backgroundColor: Colors.white,
                label: Text('借出'),
                labelStyle: TextStyle(
                    color: _type == LendBorrowType.BORROW
                        ? Color.fromRGBO(255, 214, 12, 1)
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
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.white)),
                labelPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 4),
                backgroundColor: Colors.white,
                label: Text('借入'),
                labelStyle: TextStyle(
                    color: _type == LendBorrowType.LEND
                        ? Color.fromRGBO(255, 214, 12, 1)
                        : Colors.black),
                onPressed: () {
                  setState(() {
                    _type = LendBorrowType.LEND;
                  });
                },
              ),
            ],
          ),
          Offstage(
            offstage: _type == LendBorrowType.BORROW && _sampleProduct == null,
            child: Column(
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
//                      Text(
//                        '（若无图片可不上传）',
//                        style: TextStyle(color: Colors.red, fontSize: 14),
//                      )
                    ],
                  ),
                ),
                EditableAttachments(list: _pictures,maxNum: _type == LendBorrowType.BORROW ? _pictures.length : 5,)
              ],
            ),
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 17.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 100,
                              child: Text(
                                '样衣名称',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                child: _nameText,
                              ),
                              onTap: () async {
                                _sampleProduct =
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SampleProductsPage(
                                            isHistoryCreate: true),
                                  ),
                                );
                                if(_sampleProduct != null){
                                  _nameText = Text(_sampleProduct.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16));
                                  _skuIDText = _sampleProduct.code;
                                  _pictures = _sampleProduct.pictures;
                                }
                              },
                            ),

                          ],
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
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15, vertical: 17.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 100,
                              child: Text(
                                '货号',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Text(_skuIDText,style: TextStyle(fontSize: 16),)
                          ],
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
                        leadingText: Text('样衣名称',style: TextStyle(fontSize: 16,)),
                        hintText: '请输入样衣名称',
                        leadingWidth: 100,
                      ),
                      TextFieldComponent(
                        focusNode: _skuIDFocusNode,
                        controller: _skuIDController,
                        leadingText: Text('货号',style: TextStyle(fontSize: 16,)),
                        hintText: '请输入货号',
                        leadingWidth: 100,
                      ),
                    ],
                  ),
                  TextFieldComponent(
                    focusNode: _quantityFocusNode,
                    controller: _quantityController,
                    leadingText: Text(_type == LendBorrowType.BORROW ? '借出数量' : '借入数量',style: TextStyle(fontSize: 16,)),
                    hintText:
                    _type == LendBorrowType.BORROW ? '请输入借出数量' : '请输入借入数量',
                    leadingWidth: 100,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            '预计归还时间',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        GestureDetector(
                          child: _expectedReturnDateText,
                          onTap: () {
                            _selectDate(context).then((value) {
                              setState(() {
                                widget.model.expectedReturningDate = value;
                                if (value != null) {
                                  _expectedReturnDateText =
                                      Text(DateFormatUtil.formatYMD(value));
                                } else {
                                  _expectedReturnDateText = Text(
                                    '点击选择日期',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  );
                                }
                              });
                            });
                          },
                        )
                      ],
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
                    leadingText: Text('备注',style: TextStyle(fontSize: 16,)),
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
                    leadingText: Text('关联方',style: TextStyle(fontSize: 16,)),
                    hintText:
                    _type == LendBorrowType.BORROW ? '我借给谁的' : '谁借给我的',
                    leadingWidth: 100,
                  ),
                  TextFieldComponent(
                    focusNode: _contactWayFocusNode,
                    controller: _contactWayController,
                    leadingText: Text('联系方式',style: TextStyle(fontSize: 16,)),
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
      initialDate: widget.model.expectedReturningDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
  }
}
