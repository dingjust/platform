import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class MyCompanyContactFromWidgetPage extends StatefulWidget{
  B2BUnitModel company;
  bool isEditing;
  bool isScroll;

  MyCompanyContactFromWidgetPage({this.company,this.isEditing = false,this.isScroll = false,Key key,}):super(key:key);

  _MyCompanyContactFromWidgetPageState createState() => _MyCompanyContactFromWidgetPageState();
}

class _MyCompanyContactFromWidgetPageState extends State<MyCompanyContactFromWidgetPage>{
  String btnText = '编辑';
  bool isEditing = false;
  AddressModel addressModel;

  TextEditingController personController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController QQController = TextEditingController();
  TextEditingController weCharController = TextEditingController();

  FocusNode personFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode telFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode QQFocusNode = FocusNode();
  FocusNode weCharFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if(widget.company.contactAddress != null){
      addressModel = widget.company.contactAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildContactPerson(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildContactPhone(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildContactAddress(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildCellPhone(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildEmail(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildQQ(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(height: 0,),
            ),
            _buildWeChar(context),
//            Padding(
          ],
        ),
      ],
    );
  }

  Widget _buildContactPerson(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: personFocusNode,
          leadingText: Text('联系人',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.text,
          textAlign: TextAlign.right,
          controller: personController,
        ),
      )
      :Container(
        child: ListTile(
         leading: Container(
                child: Text(
                  '联系人',
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
          trailing : Container(
              child: Text(
                '${widget.company.contactPerson==null?'':widget.company.contactPerson}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),
              ),
            ),
        ),
      ),
    );
  }

  Widget _buildContactPhone(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: phoneFocusNode,
          leadingText: Text('联系电话',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.phone,
          textAlign: TextAlign.right,
          controller: phoneController,
        ),
      )
        :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '联系电话',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.contactPhone==null?'':widget.company.contactPhone}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          _selectActionButton(widget.company.contactPhone);
        },
      ),
    );
  }

  Widget _buildContactAddress(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 20),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 100,
              child: Text(
                '经营地址',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              width: MediaQueryData.fromWindow(window).size.width - 130,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${widget.company.contactAddress != null && widget.company.contactAddress.details != null ? widget.company.contactAddress.details : ''}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          copyToClipboard(widget.company.contactAddress.details,context);
        },
      ),
    );
  }

  Widget _buildCellPhone(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: telFocusNode,
          leadingText: Text('座机号码',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.phone,
          textAlign: TextAlign.right,
          controller: telController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '座机号码',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.phone== null ? '':widget.company.phone}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          _selectActionButton(widget.company.phone);
        },
      ),
    );
  }

  Widget _buildEmail(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: emailFocusNode,
          leadingText: Text('邮箱地址',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.emailAddress,
          textAlign: TextAlign.right,
          controller: emailController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              '邮箱地址',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.email==null  || widget.company.email == 'xiaoyongkuang@nbyjy.net'?'':widget.company.email}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          copyToClipboard(widget.company.email,context);
        },
      ),
    );
  }

  Widget _buildQQ(BuildContext context){
    return Container(
      child: isEditing?
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: TextFieldComponent(
          padding: EdgeInsets.symmetric(vertical: 5),
          dividerPadding: EdgeInsets.only(),
          focusNode: QQFocusNode,
          leadingText: Text('QQ号码',
              style: TextStyle(
                fontSize: 16,
              )),
          hintText: '填写',
          autofocus: false,
          inputType: TextInputType.text,
          textAlign: TextAlign.right,
          controller: QQController,
        ),
      )
          :GestureDetector(
        child: ListTile(
          leading: Container(
            child: Text(
              'QQ号码',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          trailing : Container(
            child: Text(
              '${widget.company.qq==null?'':widget.company.qq}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: (){
          copyToClipboard(widget.company.qq,context);
        },
      ),
    );
  }

  Widget _buildWeChar(BuildContext context){
    return Container(
      child: Container(
        child: isEditing?
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFieldComponent(
            padding: EdgeInsets.symmetric(vertical: 5),
            dividerPadding: EdgeInsets.only(),
            focusNode: weCharFocusNode,
            leadingText: Text('微信号码',
                style: TextStyle(
                  fontSize: 16,
                )),
            hintText: '填写',
            autofocus: false,
            inputType: TextInputType.text,
            textAlign: TextAlign.right,
            controller: weCharController,
          ),
        )
            :GestureDetector(
          child: ListTile(
            leading: Container(
              child: Text(
                '微信号码',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            trailing : Container(
              child: Text(
                '${widget.company.wechat==null?'':widget.company.wechat}',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey
                ),
              ),
            ),
          ),
          onTap: (){
            copyToClipboard(widget.company.wechat,context);
          },
        ),
      ),
    );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel) async {
    if(tel.length == 0)return;
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
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            successTips: '复制成功',
            callbackResult: true,
            confirmAction: (){
              Navigator.of(context).pop();
            },
          );
        }
    );
//    ShowDialogUtil.showSimapleDialog(context, '复制成功');
  }
}