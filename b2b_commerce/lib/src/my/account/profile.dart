import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'reset_password_by_password.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _nameTextEditingController = TextEditingController();

  FocusNode _phoneFocusNode = FocusNode();
  TextEditingController _phoneTextEditingController = TextEditingController();

  MediaModel media;

  String phoneValidateStr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserModel currentUser = UserBLoC.instance.currentUser;
    media = currentUser.profilePicture;
    _nameTextEditingController.text = currentUser.name;
    _phoneTextEditingController.text = currentUser.contactPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人资料'),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: Color.fromRGBO(255, 219, 0, 1),
        actions: <Widget>[
          FlatButton(
            child: Text('保存'),
            onPressed: onSubmit,
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _InputRow(
                label: '头像',
                height: 120,
                child: Row(
                  children: <Widget>[
                    SingleAttachment(
                      media: media,
                      width: 100,
                      onChanged: _handleMediaChanged,
                    ),
                  ],
                )),
            _InputRow(
              label: '昵称',
              child: TextField(
                controller: _nameTextEditingController,
                focusNode: _nameFocusNode,
                onChanged: (val) {
                  if (val.length > 10) {
                    setState(() {
                      _nameTextEditingController.text = val.substring(0, 10);
                      _nameFocusNode.unfocus();
                    });
                  }
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入昵称',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            _InputRow(
              label: '联系方式',
              child: TextField(
                controller: _phoneTextEditingController,
                focusNode: _phoneFocusNode,
                inputFormatters: [
                  DecimalInputFormat(),
                ],
                onChanged: (val) => phoneValidate(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入联系方式',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      '$phoneValidateStr',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )
              ],
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push((MaterialPageRoute(
                    builder: (context) => ResetPasswordByPasswordPage())));
              },
              child: _InputRow(
                label: '修改密码',
                padding: EdgeInsets.symmetric(vertical: 10),
                suffix: Icon(Icons.chevron_right),
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: UserRepositoryImpl().updateUserInfo(
                UserBLoC.instance.currentUser.uid,
                _nameTextEditingController.text,
                _phoneTextEditingController.text,
                media),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: '',
          );
        }).then((value) {
      if (value != null && value) {
        //刷新用户信息
        UserBLoC.instance.refreshUser().then((val) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        });
      }
    });
  }

  void _handleMediaChanged(MediaModel newValue) {
    setState(() {
      media = newValue;
    });
  }

  void phoneValidate() {
    if (!RegexUtil.isMobile(_phoneTextEditingController.text)) {
      setState(() {
        phoneValidateStr = '输入正确手机号';
      });
    } else {
      setState(() {
        phoneValidateStr = '';
      });
    }
  }
}

class _InputRow extends StatelessWidget {
  final String label;

  final Widget child;

  final Widget suffix;

  final double labelWidth;

  final double height;

  final EdgeInsetsGeometry padding;

  const _InputRow({Key key,
    this.label,
    this.child,
    this.suffix,
    this.labelWidth = 100,
    this.height = 70,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: labelWidth,
              child: Text(
                '$label',
                style: TextStyle(fontSize: 18),
              ),
            ),
            child != null ? Expanded(flex: 1, child: child) : Container(),
            suffix != null ? suffix : Container()
          ],
        ));
  }
}
