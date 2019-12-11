import 'dart:ui';

import 'package:b2b_commerce/src/my/my_company_certificate_select.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyCompanyContactInfo extends StatefulWidget {
  CompanyModel company;
  bool onlyRead;

  MyCompanyContactInfo(
    this.company, {
    this.onlyRead = false,
        Key key,
  }):super(key:key);

  MyCompanyContactInfoState createState() =>
      MyCompanyContactInfoState();
}

class MyCompanyContactInfoState extends State<MyCompanyContactInfo> {
  final double TITLE_WIDTH = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: _buildContactInfo(),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column _buildContactInfo() {
    return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
            child: Row(
              children: <Widget>[
                Text('企业信息',style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    '联系人',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Text(
                  widget.company.contactPerson ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    '手机号码',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.company.contactPhone ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.phone,color: Color(0xffffd60c),),
                  ),
                  onTap: (){
                    _selectActionButton(widget.company.contactPhone);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    '座机号码',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.company.phone ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.phone,color: Color(0xffffd60c),),
                  ),
                  onTap: (){
                    _selectActionButton(widget.company.phone);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    'QQ号',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.company.qq ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.content_copy,color: Color(0xffffd60c),),
                  ),
                  onTap: (){
                    copyToClipboard(widget.company.qq);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    '微信号',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.company.wechat ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(Icons.content_copy,color: Color(0xffffd60c),),
                  ),
                  onTap: (){
                    copyToClipboard(widget.company.wechat);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: TITLE_WIDTH,
                  child: Text(
                    '经营地址',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.company.contactAddress.details ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel) async {
    if(tel == null || tel == ''){
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
            tel.indexOf('-') > -1
                ? Container()
                : ListTile(
              leading: Icon(Icons.message),
              title: Text('发送短信'),
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

  copyToClipboard(final String text) {
    if (text != null) {
      Clipboard.setData(ClipboardData(text: text));
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              successTips: '复制成功',
              callbackResult: true,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
    }
  }
}
