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
    _phoneController.text = widget.company.contactPhone;
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
                  shape:  RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  label: Text(btnText),
                  onPressed: () async{
                      if (!isEditing) {
                        setState(() {
                          isEditing = !isEditing;
                          btnText = '确定';
                        });
                      } else {
                        widget.company.contactAddress = address;
                        widget.company.contactPhone = _phoneController.text == '' ? null : _phoneController.text;
                        widget.company.email = _emailController.text == '' || _emailController.text == 'xiaoyongkuang@nbyjy.net' ? null : _emailController.text;
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
                                Text('${widget.company.contactPerson ?? ''}',style: TextStyle(color: Colors.grey,fontSize: 16,),),
                              ],
                            ),
//                            SizedBox(height: 5,),
//                            Text('${widget.company.contactPhone ?? ''}',style: TextStyle(color: Colors.grey,fontSize: 16,),),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(height: 0,color: Color(Constants.DIVIDER_COLOR),),
                    ),
                  ],
                ),
                InkWell(
                    child: TextFieldComponent(
                      style: TextStyle(color: Colors.grey,fontSize: 16,),
                      enabled: isEditing,
                      focusNode: _phoneFocusNode,
                      leadingText: Text('联系电话',style: TextStyle(fontSize: 16,)),
                      controller: _phoneController,
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
                    leadingText: Text('邮箱地址',style: TextStyle(fontSize: 16,)),
                    controller: _emailController,
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
                    leadingText: Text('QQ号',style: TextStyle(fontSize: 16,)),
                    controller: _qqController,
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
                    leadingText: Text('微信号',style: TextStyle(fontSize: 16,)),
                    controller: _wechatController,
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
  }

}
