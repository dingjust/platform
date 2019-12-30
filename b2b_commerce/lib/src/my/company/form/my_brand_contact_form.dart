import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class MyBrandContactFormPage extends StatefulWidget {
  B2BUnitModel company;

  bool isEditing;
  bool isDetail;

  MyBrandContactFormPage({
    this.company,
    this.isEditing = false,
    this.isDetail = false,
  });

  _MyBrandContactFormPageState createState() =>
      _MyBrandContactFormPageState();
}

class _MyBrandContactFormPageState extends State<MyBrandContactFormPage> {
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _contactPhoneController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dutiesController = TextEditingController();

  FocusNode _contactPersonFocusNode = FocusNode();
  FocusNode _contactPhoneFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _dutiesFocusNode = FocusNode();
  double _fontSize = 16;

  @override
  void initState() {
    super.initState();
    _contactPersonController.text = widget.company.contactPerson;
    _contactPhoneController.text = widget.company.contactPhone;
    _phoneController.text = widget.company.phone;
    _dutiesController.text = widget.company.duties;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系信息'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('保存', style: TextStyle(color: Color(0xffffd60c))),
              onPressed: () {
                widget.company.contactPerson = _contactPersonController.text == ''
                    ? null
                    : _contactPersonController.text;
                widget.company.contactPhone = _contactPhoneController.text == ''
                    ? null
                    : _contactPhoneController.text;
                widget.company.duties = _dutiesController.text == ''
                    ? null
                    : _dutiesController.text;
                widget.company.phone =
                _phoneController.text == '' ? null : _phoneController.text;
                Navigator.pop(context);
              }),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            _buildEmail(context),
            Divider(
              height: 1,
            ),
            _buildContactPerson(context),
            Divider(
              height: 1,
            ),
            _buildContactPhone(context),
            Divider(
              height: 1,
            ),
//            _buildContactAddress(context),
//            Divider(
//              height: 1,
//            ),
            _buildCellPhone(context),
            Divider(
              height: 1,
            ),
//            _buildQQ(context),
//            Divider(
//              height: 1,
//            ),
//            _buildWeChar(context),
//            Divider(
//              height: 1,
//            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactPerson(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '姓名',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red)
                  ),
                ]
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextFieldComponent(
                padding: EdgeInsets.all(0),
                focusNode: _contactPersonFocusNode,
                controller: _contactPersonController,
                hintText: '请输入姓名',
                hideDivider: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPhone(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '手机',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red)
                  ),
                ]
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextFieldComponent(
                padding: EdgeInsets.all(0),
                focusNode: _contactPhoneFocusNode,
                controller: _contactPhoneController,
                hintText: '请输入手机号码',
                hideDivider: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCellPhone(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '座机号码',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                ]
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextFieldComponent(
                padding: EdgeInsets.all(0),
                focusNode: _phoneFocusNode,
                controller: _phoneController,
                hintText: '请输入座机号码',
                hideDivider: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5,),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                      text: '职务',
                      style: TextStyle(color: Colors.black,fontSize: _fontSize,)
                  ),
                  TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red)
                  ),
                ]
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: TextFieldComponent(
                padding: EdgeInsets.all(0),
                focusNode: _dutiesFocusNode,
                controller: _dutiesController,
                hintText: '请输入职务',
                hideDivider: true,
              ),
            ),
          ),
        ],
      ),
    );
  }


  //拨打电话或发短信
  void _selectActionButton(String tel) async {
    if (tel == null || tel == '') return;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
              leading: const Icon(Icons.message),
              title: const Text('发送短信'),
              onTap: () async {
                var url = 'sms:' + tel;
                await launch(url);
              },
            ),
          ],
        );
      },
    );
  }

  copyToClipboard(final String text, BuildContext context) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text));
    ShowDialogUtil.showSimapleDialog(context, '复制成功');
  }
}
