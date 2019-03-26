import 'package:b2b_commerce/src/common/address_picker.dart';
import 'package:b2b_commerce/src/production/offline_contacts_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class MyCompanyContactWayPage extends StatefulWidget {
  B2BUnitModel company;

  MyCompanyContactWayPage(this.company);

  State createState() => MyCompanyContactWayPageState();
}

class MyCompanyContactWayPageState extends State<MyCompanyContactWayPage> {
  bool isEditing = false;
  String btnText = '编辑';
  TextEditingController _contactPersonController = TextEditingController();
  FocusNode _contactPersonFocusNode = FocusNode();
  TextEditingController _contactPhoneController = TextEditingController();
  FocusNode _contactPhoneFocusNode = FocusNode();
  TextEditingController _addressController = TextEditingController();
  FocusNode _addressFocusNode = FocusNode();
  TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  TextEditingController _qqController = TextEditingController();
  FocusNode _qqFocusNode = FocusNode();
  TextEditingController _wechatController = TextEditingController();
  FocusNode _wechatFocusNode = FocusNode();

  @override
  void initState() {
    _contactPersonController.text = widget.company.contactPerson;
    _contactPhoneController.text = widget.company.contactPhone;
    _addressController.text = widget.company.address;
    _phoneController.text = widget.company.phone;
    _emailController.text = widget.company.email;
    _qqController.text = widget.company.qq;
    _wechatController.text = widget.company.wechat;
    if(widget.company.contactAddress == null) widget.company.contactAddress = AddressModel();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('联系方式'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          Container(
              width: 80,
              child: ActionChip(
                label: Text(btnText),
                onPressed: () {
                  setState(() {
                    if (!isEditing) {
                      isEditing = !isEditing;
                      btnText = '确定';
                    } else {
                      //TODO:提交表单
                      btnText = '编辑';
                    }
                  });
                },
                backgroundColor: Color.fromRGBO(255, 214, 12, 1),
              )),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
//                TextFieldComponent(
//                  enabled: isEditing,
//                  focusNode: _contactPersonFocusNode,
//                  leadingText: '联系人',
//                  controller: _contactPersonController,
//                  leadingColor: Colors.grey,
//                  dividerPadding: EdgeInsets.all(0),
//                ),
//                InkWell(
//                  child: TextFieldComponent(
//                    enabled: isEditing,
//                    focusNode: _contactPhoneFocusNode,
//                    leadingText: '联系电话',
//                    controller: _contactPhoneController,
//                    leadingColor: Colors.grey,
//                    dividerPadding: EdgeInsets.all(0),
//                    trailing: isEditing
//                        ? null
//                        : Icon(
//                            Icons.phone,
//                            size: 14,
//                            color: Color.fromRGBO(255, 214, 12, 1),
//                          ),
//                  ),
//                  onTap: () {
//                    if (!isEditing)
//                      _selectActionButton(
//                          _contactPhoneController.text, context);
//                  },
//                ),
                ListTile(
                  title: Text('经营地址',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  trailing: Icon(Icons.chevron_right),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OfflineContactsInput(model: widget.company.contactAddress,)));
                  },
                ),
                Divider(height: 0,color: Colors.grey,),
//                InkWell(
//                  child: TextFieldComponent(
//                    enabled: isEditing,
//                    focusNode: _addressFocusNode,
//                    leadingText: '经营地址',
//                    controller: _addressController,
//                    leadingColor: Colors.grey,
//                    dividerPadding: EdgeInsets.all(0),
//                    trailing: isEditing
//                        ? null
//                        : Icon(
//                            Icons.content_copy,
//                            size: 14,
//                            color: Color.fromRGBO(255, 214, 12, 1),
//                          ),
//                  ),
//                  onTap: () {
//                    if (!isEditing)
//                      copyToClipboard(_addressController.text, context);
//                  },
//                ),
                InkWell(
                    child: TextFieldComponent(
                      enabled: isEditing,
                      focusNode: _phoneFocusNode,
                      leadingText: '座机号码',
                      controller: _phoneController,
                      leadingColor: Colors.grey,
                      dividerPadding: EdgeInsets.all(0),
                      trailing: isEditing
                          ? null
                          : Icon(
                              Icons.phone,
                              size: 14,
                              color: Color.fromRGBO(255, 214, 12, 1),
                            ),
                    ),
                    onTap: () {
                      if (!isEditing)
                        _selectActionButton(_phoneController.text, context);
                    }),
                InkWell(
                  child: TextFieldComponent(
                    enabled: isEditing,
                    focusNode: _emailFocusNode,
                    leadingText: '邮箱地址',
                    controller: _emailController,
                    leadingColor: Colors.grey,
                    dividerPadding: EdgeInsets.all(0),
                    trailing: isEditing
                        ? null
                        : Icon(
                            Icons.content_copy,
                            size: 14,
                            color: Color.fromRGBO(255, 214, 12, 1),
                          ),
                  ),
                  onTap: () {
                    if (!isEditing)
                      copyToClipboard(_emailController.text, context);
                  },
                ),
                InkWell(
                  child: TextFieldComponent(
                    enabled: isEditing,
                    focusNode: _qqFocusNode,
                    leadingText: 'QQ号',
                    controller: _qqController,
                    leadingColor: Colors.grey,
                    dividerPadding: EdgeInsets.all(0),
                    trailing: isEditing
                        ? null
                        : Icon(
                            Icons.content_copy,
                            size: 14,
                            color: Color.fromRGBO(255, 214, 12, 1),
                          ),
                  ),
                  onTap: () {
                    if (!isEditing)
                      copyToClipboard(_qqController.text, context);
                  },
                ),
                InkWell(
                  child: TextFieldComponent(
                    enabled: isEditing,
                    focusNode: _wechatFocusNode,
                    leadingText: '微信号',
                    controller: _wechatController,
                    leadingColor: Colors.grey,
                    dividerPadding: EdgeInsets.all(0),
                    trailing: isEditing
                        ? null
                        : Icon(
                            Icons.content_copy,
                            size: 14,
                            color: Color.fromRGBO(255, 214, 12, 1),
                          ),
                  ),
                  onTap: () {
                    if (!isEditing)
                      copyToClipboard(_wechatController.text, context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel, BuildContext context) async {
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

  copyToClipboard(final String text, BuildContext context) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text));
    _neverCopyContent(context);
  }

  Future<void> _neverCopyContent(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('消息'),
          content: Text('复制成功'),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
