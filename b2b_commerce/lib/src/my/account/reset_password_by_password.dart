import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart' show UserBLoC, UserRepositoryImpl;
import 'package:widgets/widgets.dart';

class ResetPasswordByPasswordPage extends StatefulWidget {
  const ResetPasswordByPasswordPage({
    Key key,
  }) : super(key: key);

  _ResetPasswordByPasswordPageState createState() =>
      _ResetPasswordByPasswordPageState();
}

class _ResetPasswordByPasswordPageState
    extends State<ResetPasswordByPasswordPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool validate = false;
  String phoneValidateStr = "";

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _againPasswordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.5,
            title: Text('修改密码'),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(255, 219, 0, 1),
            actions: <Widget>[
              FlatButton(
                child: Text('保存'),
                onPressed: onSubmit,
              )
            ],
          ),
          body: Form(
            key: _formKey,
            autovalidate: true,
            child: _buildBody(context),
          )),
    );
  }

  Widget _buildInputArea() {
    TextFormField _olPasswordField = TextFormField(
        autofocus: false,
        controller: _oldPasswordController,
        obscureText: true,
        decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
        validator: (v) {
          return v.trim().length > 0 ? null : "原密码不能为空";
        });

    TextFormField _passwordField = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
      validator: (value) {
        if (!RegexUtil.password(value)) {
          return '6~20位字母与数字组合，首位为字母';
        } else {
          return null;
        }
      },
    );

    TextFormField _againPasswordField = TextFormField(
      autofocus: false,
      controller: _againPasswordController,
      obscureText: true,
      decoration: InputDecoration(hintText: '请输入', border: InputBorder.none),
      validator: (value) {
        return _againPasswordController.text == _passwordController.text
            ? null
            : '密码不一致';
      },
    );

    _againPasswordController.addListener(() {
      formValidate();
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 85,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '原密码',
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _olPasswordField,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 85,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '密码',
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _passwordField,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 85,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(
                    '再次输入',
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _againPasswordField,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    bloc.loginStream.listen((result) {
      Navigator.pop(context);
      showDialog(
          context: context,
          child: SimpleDialog(
            title: Text('登录失败'),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Text('${result}'),
              ),
            ],
          ));
    });

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(
          'temp/login_background.png',
          package: "assets",
        ),
        fit: BoxFit.fitWidth,
      )),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        children: <Widget>[
          _buildInputArea(),
        ],
      ),
    );
  }

  Future<bool> validatePhone() async {
    String result = "";
    bool isExist = false;

    if (_phoneController.text == '') {
      result = '';
    } else {
      if (RegexUtil.isMobile(_phoneController.text)) {
        UserType type =
            await UserRepositoryImpl().phoneExist(_phoneController.text);

        if (type != null && type != UserType.DEFAULT) {
          result = "";
          isExist = true;
        } else {
          result = "账号不存在";
        }
      } else {
        result = "输入正确手机号";
      }
    }

    setState(() {
      phoneValidateStr = result;
    });

    return isExist;
  }

  void formValidate() {
    setState(() {
      validate = _phoneController.text.trim().length > 0 &&
          _smsCaptchaController.text.trim().length > 0 &&
          _passwordController.text.trim().length > 0 &&
          _againPasswordController.text.trim().length > 0 &&
          _passwordController.text == _againPasswordController.text;
    });
  }

  void onSubmit() async {
    if (_againPasswordController.text != _passwordController.text ||
        _passwordController.text == '' ||
        _oldPasswordController.text == '') {
      print('!');
      return;
    }

    if (!(_formKey.currentState as FormState).validate()) {
      print('!!!!!');
      return;
    }

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (_) {
    //       return RequestDataLoading(
    //         requestCallBack: UserRepositoryImpl().resetPasswordByPassword(
    //           _oldPasswordController.text,
    //           _passwordController.text,
    //           UserBLoC.instance.currentUser.uid,
    //         ),
    //         outsideDismiss: false,
    //         loadingText: '保存中。。。',
    //         entrance: '',
    //       );
    //     }).then((value) {
    //   bool result = value as bool;
    //   if (result) {
    //     Navigator.of(context).pop();
    //   } else {
    //     BotToast.showText(text: "密码错误"); //弹出一个文本框;
    //   }
    // });

    // 加载条
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          ProgressIndicatorFactory.buildDefaultProgressIndicator(),
    );

    bool response = await UserRepositoryImpl().resetPasswordByPassword(
      _oldPasswordController.text,
      _passwordController.text,
      UserBLoC.instance.currentUser.uid,
    );
    Navigator.of(context).pop();
    if (response) {
      Navigator.of(context).pop();
    } else {
      BotToast.showText(text: "密码错误"); //弹出一个文本框;
    }
  }
}

class PrefixText extends StatelessWidget {
  final String text;

  const PrefixText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: Text(
        text,
        style: TextStyle(color: Color.fromRGBO(36, 38, 41, 1)),
      ),
      margin: EdgeInsets.only(right: 20),
    );
  }
}
