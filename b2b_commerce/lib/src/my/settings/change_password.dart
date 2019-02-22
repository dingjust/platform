import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class ChangePasswordPage extends StatefulWidget {
  ChangePasswordStatePage createState() => ChangePasswordStatePage();
}

class ChangePasswordStatePage extends State<ChangePasswordPage> {
  FocusNode _oldPasswordFocusNode = FocusNode();
  FocusNode _newPasswordFocusNode = FocusNode();
  FocusNode _confNewPasswordFocusNode = FocusNode();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confNewPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('修改密码'),
        actions : <Widget>[
          IconButton(icon: Icon(Icons.done), onPressed: () {
            Navigator.pop(context);
          }),
        ],
      ),
      body: ListView(
        children: <Widget>[
          TextFieldComponent(
            focusNode: _oldPasswordFocusNode,
            controller: _oldPasswordController,
            leadingText: '旧密码',
            hintText: '请输入旧密码',
            leadingWidth: 60,
          ),
          TextFieldComponent(
            focusNode: _newPasswordFocusNode,
            controller: _newPasswordController,
            leadingText: '新密码',
            hintText: '请输入新密码',
            leadingWidth: 60,
          ),
          TextFieldComponent(
            focusNode: _confNewPasswordFocusNode,
            controller: _confNewPasswordController,
            leadingText: '确认密码',
            hintText: '请输入确认密码',
            leadingWidth: 60,
          ),
        ],
      ),
    );
  }
}
