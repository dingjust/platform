import 'package:b2b_commerce/src/production/offline_contacts_input.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class MyCompanyContactWayPage extends StatefulWidget {
  B2BUnitModel company;
  bool isCompanyIntroduction;

  MyCompanyContactWayPage(this.company,{this.isCompanyIntroduction = false});

  State createState() => MyCompanyContactWayPageState();
}

class MyCompanyContactWayPageState extends State<MyCompanyContactWayPage> {
  bool isEditing = false;
  String btnText = '编辑';
  TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _emailController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  TextEditingController _qqController = TextEditingController();
  FocusNode _qqFocusNode = FocusNode();
  TextEditingController _wechatController = TextEditingController();
  FocusNode _wechatFocusNode = FocusNode();

  AddressModel address;

  @override
  void initState() {
    _phoneController.text = widget.company.phone;
    _emailController.text = widget.company.email;
    _qqController.text = widget.company.qq;
    _wechatController.text = widget.company.wechat;
    address = widget.company.contactAddress;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (address == null) address = AddressModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('联系方式'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          Offstage(
            offstage: !widget.isCompanyIntroduction,
            child: Container(
                width: 80,
                child: ActionChip(
                  label: Text(btnText),
                  onPressed: () async{
                      if (!isEditing) {
                        setState(() {
                          isEditing = !isEditing;
                          btnText = '确定';
                        });
                      } else {
                        widget.company.contactAddress = address;
                        widget.company.phone = _phoneController.text == '' ? null : _phoneController.text;
                        widget.company.email = _emailController.text == '' ? null : _emailController.text;
                        widget.company.qq = _qqController.text == '' ? null : _qqController.text;
                        widget.company.wechat = _wechatController.text == '' ? null : _wechatController.text;
                        print(CompanyModel.toJson(widget.company));

                        if(UserBLoC.instance.currentUser.type == UserType.BRAND){
                          UserRepositoryImpl().brandUpdate(widget.company).then((a){
                            setState(() {
                              btnText = '编辑';
                              isEditing = !isEditing;
                            });
                          });
                        }else if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
                          UserRepositoryImpl().factoryUpdate(widget.company).then((a){
                            setState(() {
                              btnText = '编辑';
                              isEditing = !isEditing;
                            });
                          });
                        }
                      }
                  },
                  backgroundColor: Color.fromRGBO(255, 214, 12, 1),
                )),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('联系人',style: TextStyle(fontSize: 16,),),
                                Text('${address.fullname ?? ''}',style: TextStyle(color: Colors.grey,fontSize: 16,),),
                              ],
                            ),
                            SizedBox(height: 5,),
                            Text('${address.cellphone ?? ''}',style: TextStyle(color: Colors.grey,fontSize: 16,),),
                            SizedBox(height: 5,),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '经营地址',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Offstage(
                                  offstage: !widget.isCompanyIntroduction,
                                  child: Icon(
                                    Icons.chevron_right,
                                    color: this.isEditing ? Colors.grey : Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0,top: 10),
                              child: Text(
                                address != null && address.region != null
                                    ? address.details
                                    : '',
                                style: TextStyle(color: Colors.grey,fontSize: 16,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        if(!this.isEditing) return;
                        dynamic result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OfflineContactsInput(
                                      model: address,
                                    )));
                        if (result != null) address = result;
                      },
                    ),
                    Container(
//                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        height: 0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                InkWell(
                    child: TextFieldComponent(
                      style: TextStyle(color: Colors.grey,fontSize: 16,),
                      enabled: isEditing,
                      focusNode: _phoneFocusNode,
                      leadingText: '座机号码',
                      controller: _phoneController,
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
                      if (!isEditing && _phoneController.text.length > 0)
                        _selectActionButton(_phoneController.text, context);
                    }),
                InkWell(
                  child: TextFieldComponent(
                    style: TextStyle(color: Colors.grey,fontSize: 16,),
                    enabled: isEditing,
                    focusNode: _emailFocusNode,
                    leadingText: '邮箱地址',
                    controller: _emailController,
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
                    if (!isEditing && _emailController.text.length > 0) copyToClipboard(_emailController.text, context);
                  },
                ),
                InkWell(
                  child: TextFieldComponent(
                    style: TextStyle(color: Colors.grey,fontSize: 16,),
                    enabled: isEditing,
                    focusNode: _qqFocusNode,
                    leadingText: 'QQ号',
                    controller: _qqController,
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
                    if (!isEditing && _qqController.text.length > 0) copyToClipboard(_qqController.text, context);
                  },
                ),
                InkWell(
                  child: TextFieldComponent(
                    style: TextStyle(color: Colors.grey,fontSize: 16,),
                    enabled: isEditing,
                    focusNode: _wechatFocusNode,
                    leadingText: '微信号',
                    controller: _wechatController,
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
                    if (!isEditing && _wechatController.text.length > 0) copyToClipboard(_wechatController.text, context);
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
      barrierDismissible: true, // user must tap button!
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
