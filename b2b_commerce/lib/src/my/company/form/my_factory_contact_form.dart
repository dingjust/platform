import 'dart:ui';

import 'package:b2b_commerce/src/my/address/contact_address_form.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

class MyFactoryContactFormPage extends StatefulWidget {
  B2BUnitModel company;

  bool isEditing;
  bool isDetail;

  MyFactoryContactFormPage({
    this.company,
    this.isEditing = false,
    this.isDetail = false,
  });

  _MyFactoryContactFormPageState createState() =>
      _MyFactoryContactFormPageState();
}

class _MyFactoryContactFormPageState extends State<MyFactoryContactFormPage> {
  String btnText = '编辑';
  bool isEditing = false;

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
    isEditing = widget.isEditing;
    personController.text = widget.company.contactPerson;
    phoneController.text = widget.company.contactPhone;
    telController.text = widget.company.phone;
    if (widget.company.email == 'xiaoyongkuang@nbyjy.net') {
      emailController.text = null;
    } else {
      emailController.text = widget.company.email;
    }

    QQController.text = widget.company.qq;
    weCharController.text = widget.company.wechat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('联系方式'),
//        centerTitle: true,
//        elevation: 0.5,
//        actions: <Widget>[
//          Offstage(
//            offstage: isEditing || widget.isDetail,
//            child: Container(
//                width: 80,
//                child: ActionChip(
//                  shape: RoundedRectangleBorder(
//                      side: BorderSide.none,
//                      borderRadius: BorderRadius.all(Radius.circular(5))),
//                  label: Text('编辑'),
//                  onPressed: () async {
//                    setState(() {
//                      isEditing = !isEditing;
//                      personController.text = widget.company.contactPerson;
//                      phoneController.text = widget.company.contactPhone;
//                      telController.text = widget.company.phone;
//                      emailController.text = widget.company.email;
//                      QQController.text = widget.company.qq;
//                      weCharController.text = widget.company.wechat;
//                    });
//                  },
//                  backgroundColor: Color.fromRGBO(255, 214, 12, 1),
//                )),
//          )
//        ],
//      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          children: <Widget>[
            _buildContactPerson(context),
            Divider(
              height: 1,
            ),
            _buildContactPhone(context),
            Divider(
              height: 1,
            ),
            _buildContactAddress(context),
            Divider(
              height: 1,
            ),
            _buildCellPhone(context),
            Divider(
              height: 1,
            ),
            _buildEmail(context),
            Divider(
              height: 1,
            ),
            _buildQQ(context),
            Divider(
              height: 1,
            ),
            _buildWeChar(context),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
//      bottomNavigationBar: isEditing
//          ? Container(
//              margin: EdgeInsets.all(10),
//              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//              height: 50,
//              child: RaisedButton(
//                  color: Color.fromRGBO(255, 214, 12, 1),
//                  child: Text(
//                    '保存',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 18,
//                    ),
//                  ),
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(5))),
//                  onPressed: () async {
//                    setState(() {
//                      isEditing = false;
//                    });
//                    widget.company.contactAddress = addressModel;
//                    widget.company.contactPerson = personController.text == ''
//                        ? null
//                        : personController.text;
//                    widget.company.contactPhone = phoneController.text == ''
//                        ? null
//                        : phoneController.text;
//                    widget.company.email = emailController.text == ''
//                        ? null
//                        : emailController.text;
//                    widget.company.qq =
//                        QQController.text == '' ? null : QQController.text;
//                    widget.company.wechat = weCharController.text == ''
//                        ? null
//                        : weCharController.text;
//                    widget.company.phone =
//                        telController.text == '' ? null : telController.text;
//                    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
//                      showDialog(
//                          context: context,
//                          barrierDismissible: false,
//                          builder: (_) {
//                            return RequestDataLoading(
//                              requestCallBack: UserRepositoryImpl()
//                                  .brandUpdateContact(widget.company)
//                                  .then((a) {}), //
//                              outsideDismiss: false,
//                              loadingText: '保存中。。。',
//                              entrance: '00',
//                            );
//                          });
//                    } else if (UserBLoC.instance.currentUser.type ==
//                        UserType.FACTORY) {
//                      showDialog(
//                          context: context,
//                          barrierDismissible: false,
//                          builder: (_) {
//                            return RequestDataLoading(
//                              requestCallBack: UserRepositoryImpl()
//                                  .factoryUpdateContact(widget.company),
//                              loadingText: '保存中。。。',
//                              entrance: '00',
//                            );
//                          });
//                    }
//                  }),
//            )
//          : null,
    );
  }

  Widget _buildContactPerson(BuildContext context) {
    return Container(
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
        isRequired: true,
        inputType: TextInputType.text,
        textAlign: TextAlign.right,
        controller: personController,
        onChanged: (v) {
          widget.company.contactPerson = personController.text == ''
              ? null
              : personController.text;
        },
      )
    );
  }

  Widget _buildContactPhone(BuildContext context) {
    return Container(
      child:TextFieldComponent(
        padding: EdgeInsets.symmetric(vertical: 5),
        dividerPadding: EdgeInsets.only(),
        focusNode: phoneFocusNode,
        leadingText: Text('联系电话',
            style: TextStyle(
              fontSize: 16,
            )),
        hintText: '填写',
        autofocus: false,
        isRequired: true,
        inputType: TextInputType.phone,
        textAlign: TextAlign.right,
        controller: phoneController,
        onChanged: (v) {
          widget.company.contactPhone =
              phoneController.text == '' ? null : phoneController.text;
        },
      )
    );
  }

  Widget _buildContactAddress(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Wrap(
              children: <Widget>[
                Text(
                  '经营地址',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
              ],
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
        onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactAddressFormPage(
                    address: widget.company.contactAddress,
                    company: widget.company),
              ),
            );
          }
      ),
    );
  }

  Widget _buildCellPhone(BuildContext context) {
    return Container(
      child:TextFieldComponent(
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
        onChanged: (v) {
          widget.company.phone =
              telController.text == '' ? null : telController.text;
        },
      )
    );
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
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
        onChanged: (v) {
          widget.company.email =
              emailController.text == '' ? null : emailController.text;
        },
      )
    );
  }

  Widget _buildQQ(BuildContext context) {
    return Container(
            color: Colors.white,
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
              onChanged: (v) {
                widget.company.qq =
                    QQController.text == '' ? null : QQController.text;
              },
            ),
          );
  }

  Widget _buildWeChar(BuildContext context) {
    return Container(
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
        onChanged: (v) {
          widget.company.wechat = weCharController.text == ''
              ? null
              : weCharController.text;
        },
      ),
    );
  }


  copyToClipboard(final String text, BuildContext context) {
    if (text == null) return;
    Clipboard.setData(ClipboardData(text: text));
    ShowDialogUtil.showSimapleDialog(context, '复制成功');
  }
}
