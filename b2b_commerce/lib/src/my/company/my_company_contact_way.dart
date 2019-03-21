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

class MyCompanyContactWayPageState extends State<MyCompanyContactWayPage>{
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
                    isEditing = !isEditing;
                    if(isEditing){
                      btnText = '确定';
                    }else{

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
                InkWell(
                  child: TextFieldComponent(
                    enabled: isEditing,
                    focusNode: _contactPersonFocusNode,
                    leadingText: '联系人',
                    controller: _contactPersonController,
                    leadingColor: Colors.grey,
                  ),
                  onTap: (){
                    print('aaa');
                  },
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _contactPhoneFocusNode,
                  leadingText: '联系电话',
                  controller: _contactPhoneController,
                  leadingColor: Colors.grey,
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _addressFocusNode,
                  leadingText: '经营地址',
                  controller: _addressController,
                  leadingColor: Colors.grey,
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _phoneFocusNode,
                  leadingText: '座机号码',
                  controller: _phoneController,
                  leadingColor: Colors.grey,
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _emailFocusNode,
                  leadingText: '邮箱地址',
                  controller: _emailController,
                  leadingColor: Colors.grey,
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _qqFocusNode,
                  leadingText: 'QQ号',
                  controller: _qqController,
                  leadingColor: Colors.grey,
                ),
                TextFieldComponent(
                  enabled: isEditing,
                  focusNode: _wechatFocusNode,
                  leadingText: '微信号',
                  controller: _wechatController,
                  leadingColor: Colors.grey,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  //拨打电话或发短信
  void _selectActionButton(String tel,BuildContext context) async {
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
            tel.indexOf('-')>-1?Container():ListTile(
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

  copyToClipboard(final String text,BuildContext context) {
    if (text == null) return;
    Clipboard.setData(
        ClipboardData(text: text)
    );
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
