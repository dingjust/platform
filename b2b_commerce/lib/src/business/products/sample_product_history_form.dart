import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'sample_products.dart';

class SampleProductHistoryFormPage extends StatefulWidget {
  bool onlyRead;
  bool isCreated;
  SampleBorrowReturnHistoryModel model;

  SampleProductHistoryFormPage(this.model, {this.onlyRead = false,this.isCreated = false,});

  SampleProductHistoryFormPageState createState() =>
      SampleProductHistoryFormPageState();
}

class SampleProductHistoryFormPageState
    extends State<SampleProductHistoryFormPage> {
  bool _onlyRead = false;
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

  @override
  void initState() {
    _onlyRead = widget.onlyRead;
    if(!widget.isCreated) _type = widget.model.type;
    if(_onlyRead){
      if(widget.model.type == LendBorrowType.BORROW){
        _sampleProduct = SampleProductModel(
          code: widget.model.code,
          name: widget.model.name,
        );
      }else if(widget.model.type == LendBorrowType.LEND){
        _skuIDController.text = widget.model.code;
        _nameController.text = widget.model.name;
      }
      _pictures = widget.model.images;
      _quantityController.text = widget.model.quantity.toString();
      _remakeController.text = widget.model.remarks;
      _relatedPartyController.text = widget.model.relatedParty;
      _contactWayController.text = widget.model.contact;
    }


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('新建记录'),
        actions: <Widget>[
          _onlyRead ?
          IconButton(
            icon: Text(
            '编辑',
            style: TextStyle(),
          ),onPressed: (){
              setState(() {
                _onlyRead = false;
              });
          },):
          IconButton(
              icon: Text(
                '确定',
                style: TextStyle(),
              ),
              onPressed: () async {
                if (_type == LendBorrowType.BORROW) {
                  if (_sampleProduct == null) {
                    showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                              content: Text('样衣不能为空'),
                            ));
                    return;
                  } else {
                    widget.model.name = _sampleProduct.name;
                    widget.model.code = _sampleProduct.code;
//                    widget.model.images = _sampleProduct.pictures;
                  }
                } else {
                  if (_nameController.text == '' &&
                      _skuIDController.text == '') {
                    showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                              content: Text('样衣名称和货号不能为空'),
                            ));
                    return;
                  } else {
                    widget.model.name = _nameController.text;
                    widget.model.code = _skuIDController.text;
                  }
                }


                widget.model.images = _pictures;
                widget.model.state = ReturnState.NOT_RETURNED;
                widget.model.type = _type;
                widget.model.quantity = _quantityController.text == ''
                    ? 0
                    : int.parse(_quantityController.text);
                widget.model.contact = _contactWayController.text == ''
                    ? null
                    : _contactWayController.text;
                widget.model.remarks = _remakeController.text == ''
                    ? null
                    : _remakeController.text;
                widget.model.relatedParty = _relatedPartyController.text == ''
                    ? null
                    : _relatedPartyController.text;


                print(SampleBorrowReturnHistoryModel.toJson(widget.model));
                if(widget.isCreated){
                  ProductRepositoryImpl().createSampleHistory(widget.model).then((a){
                    Navigator.pop(context);
                  });
                }else{
                  ProductRepositoryImpl().updateSampleHistory(widget.model).then((a){
                    Navigator.pop(context);
                  });
                }


              }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          buildTypeSelectBtn(),
          buildPictures(),
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                children: <Widget>[
                  buildProduct(),
                  TextFieldComponent(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabled: !_onlyRead,
                    focusNode: _quantityFocusNode,
                    controller: _quantityController,
                    inputType: TextInputType.number,
                    leadingText:
                        _type == LendBorrowType.BORROW ? '借出数量' : '借入数量',
                    hintText:
                        _onlyRead ? '' : _type == LendBorrowType.BORROW ? '请输入借出数量' : '请输入借入数量',
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
                          child: Text(
                            _onlyRead
                                ? DateFormatUtil.formatYMD(
                                        widget.model.expectedReturningDate) ??
                                    ''
                                : DateFormatUtil.formatYMD(
                                        widget.model.expectedReturningDate) ??
                                    '点击选择日期',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          onTap: () {
                            if (_onlyRead) return;
                              _selectDate(context).then((value) {
                                setState(() {
                                  widget.model.expectedReturningDate = value;
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabled: !_onlyRead,
                    focusNode: _remakeFocusNode,
                    controller: _remakeController,
                    leadingText: '备注',
                    hintText:  _onlyRead ? '' : '请输入备注',
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
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabled: !_onlyRead,
                    focusNode: _relatedPartyFocusNode,
                    controller: _relatedPartyController,
                    leadingText: '关联方',
                    hintText:
                      _onlyRead ? '' : _type == LendBorrowType.BORROW ? '我借给谁的' : '谁借给我的',
                    leadingWidth: 100,
                  ),
                  TextFieldComponent(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    enabled: !_onlyRead,
                    focusNode: _contactWayFocusNode,
                    controller: _contactWayController,
                    leadingText: '联系方式',
                    hintText:  _onlyRead ? '' : '请输入联系方式',
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

  Offstage buildPictures() {
    return Offstage(
      offstage: _type == LendBorrowType.BORROW &&
          _sampleProduct == null &&
          !_onlyRead,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
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
          EditableAttachments(
            editable: !_onlyRead,
            list: _pictures,
            maxNum: _type == LendBorrowType.BORROW || _onlyRead
                ? _pictures.length
                : 5,
          )
        ],
      ),
    );
  }

  Widget buildTypeSelectBtn() {
    return Offstage(
      offstage: _onlyRead || !widget.isCreated,
      child: Row(
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

  Widget buildProduct() {
    print(_type);
    if(_type == LendBorrowType.BORROW){
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: 15, vertical: 17.5),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
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
                    child: Text(
                        _onlyRead ?
                        '${_sampleProduct?.name ?? ''}':
                        '${_sampleProduct?.name ?? '点击选择'}',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16)),
                  ),
                  onTap: () async {
                    if(_onlyRead) return;
                    dynamic result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SampleProductsPage(
                                isHistoryCreate: true),
                      ),
                    );

                    if (result != null) {
                      _sampleProduct = result;
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
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 100,
                  child: Text(
                    '货号',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  '${_sampleProduct?.code ?? ''}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
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
      );
    }else if(_type == LendBorrowType.LEND){
      return Column(
        children: <Widget>[
          TextFieldComponent(
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            focusNode: _nameFocusNode,
            controller: _nameController,
            leadingText: '样衣名称',
            hintText: '请输入样衣名称',
            leadingWidth: 100,
          ),
          TextFieldComponent(
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            focusNode: _skuIDFocusNode,
            controller: _skuIDController,
            leadingText: '货号',
            hintText: '请输入货号',
            leadingWidth: 100,
          ),
        ],
      );
    }
  }
}
