import 'dart:async';

import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
import 'package:b2b_commerce/src/my/account/reset_password.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart'
    show LoginResult, UserBLoC, UserRepositoryImpl, BaseResponse;
import 'package:widgets/widgets.dart';

import 'auth_login.dart';
import 'code_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
    this.snackBarMessage,
  }) : super(key: key);

  final String snackBarMessage;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey();

  TextEditingController _phoneController;
  TextEditingController _passwordController;
  TextEditingController _smsCaptchaController;
  FocusNode _phoneFocusNode;
  FocusNode _passwordFocusNode;
  FocusNode _smsFocusNode;

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = false;

  // bool validate = false;
  bool _isAgree = false;

  ///倒计时间
  int countdownTime = 60;
  final CountdownController controller = CountdownController();

  UserBLoC bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocalUserName());
    bloc = BLoCProvider.of<UserBLoC>(context);
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _smsCaptchaController = TextEditingController();
    _phoneFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _smsFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: _buildBody(context),
          )),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 38, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'img/icons/b2b-v2/logo@3x.png',
            package: 'assets',
            width: 96,
            height: 117,
          )
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          _buildLogo(),
          _buildInputArea(),
          _buildProtocolArea(),
          _buildBtn(),
          _buildInforRow(),
          OtherAuthLoginBtnGroup(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: <Widget>[
          _buildPhoneRow(),
          _divider(),
          _buildPasswordRow(),
          _divider2()
        ],
      ),
    );
  }

  ///电话输入
  Widget _buildPhoneRow() {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16),
            child: Icon(
              B2BIconsV2.phone,
              color: Color(0xFF333333),
            ),
          ),
          Expanded(
            child: TextFieldBorderComponentV2(
              padding: EdgeInsets.all(0),
              hideDivider: true,
              isRequired: true,
              textAlign: TextAlign.left,
              hintText: '请输入手机号',
              style: TextStyle(color: Color(0xFF222222), fontSize: 16),
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              onChanged: (v) {
                setState(() {});
              },
            ),
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  _phoneController.clear();
                });
              },
              child: _phoneController.text.length > 0
                  ? Container(
                      margin: EdgeInsets.only(right: 16),
                      child: Icon(
                        B2BIconsV2.del,
                        color: Color(0xFFD8D8D8),
                        size: 18,
                      ),
                    )
                  : Container())
        ],
      ),
    );
  }

  ///密码输入行
  Widget _buildPasswordRow() {
    if (_isPasswordLogin) {
      return Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16),
              child: Icon(
                B2BIconsV2.password,
                color: Color(0xFF333333),
              ),
            ),
            Expanded(
              child: TextFieldBorderComponentV2(
                padding: EdgeInsets.all(0),
                hideDivider: true,
                isRequired: true,
                textAlign: TextAlign.left,
                hintText: '请输入密码',
                style: TextStyle(color: Color(0xFF222222), fontSize: 16),
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: _isPasswordHide,
                onChanged: (v) {},
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordHide = !_isPasswordHide;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 16),
                  child: Icon(
                    _isPasswordHide ? B2BIconsV2.eye_off : B2BIconsV2.eye_on,
                    color: Color(0xFF999999),
                    size: 20,
                  ),
                ))
          ],
        ),
      );
    }
    return Container();
  }

  Widget _divider() {
    return Divider(
      color: Color(0xFFE7E7E7),
      height: 1,
    );
  }

  Widget _divider2() {
    if (_isPasswordLogin) {
      return Divider(
        color: Color(0xFFE7E7E7),
        height: 1,
      );
    }
    return Container();
  }

  Widget _buildInforRow() {
    if (_isPasswordLogin) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 120,
              child: FlatButton(
                onPressed: () {
                  var materialPageRoute = MaterialPageRoute(
                      builder: (context) => ResetPasswordPage());
                  Navigator.of(context).push(materialPageRoute);
                },
                child: Text(
                  '忘记密码',
                  style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
                ),
              ),
            ),
            Container(
              width: 1,
              height: 15,
              color: Color(0xFF222222),
            ),
            Container(
              width: 120,
              child: FlatButton(
                onPressed: _switchLoginType,
                child: Text(
                  _isPasswordLogin ? '验证码登录' : '密码登录',
                  style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
                ),
              ),
            )
          ],
        ),
      );
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: _switchLoginType,
            child: Text(
              '密码登录',
              style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
            ),
          ),
        ],
      ),
    );
    ;
  }

  Widget _buildProtocolArea({
    TextStyle style1 = const TextStyle(color: Color(0xFF222222), fontSize: 12),
    TextStyle style2 = const TextStyle(color: Color(0xFF077FFA), fontSize: 12),
  }) {
    return Container(
        margin: EdgeInsets.fromLTRB(32, 80, 32, 12),
        height: 18,
        child: Row(
          children: <Widget>[
            Container(
              width: 18,
              margin: EdgeInsets.only(right: 8),
              child: B2BCheckbox(
                value: _isAgree,
                onChanged: (value) {
                  setState(() {
                    _isAgree = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.start, //沿主轴方向居中
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    '我已阅读并同意',
                    style: style1,
                  ),
                  GestureDetector(
                    onTap: showServiceProtocol,
                    child: Text(
                      '《钉单平台服务协议》',
                      overflow: TextOverflow.clip,
                      style: style2,
                    ),
                  ),
                  Text(
                    '和',
                    style: style1,
                  ),
                  GestureDetector(
                    onTap: showPrivacyProtocol,
                    child: Text(
                      '《隐私协议》',
                      style: style2,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: showPayProtocol,
                  //   child: Text(
                  //     '《钉单平台货款代收代付服务协议》',
                  //     style: TextStyle(color: Colors.blue, fontSize: 10),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildBtn() {
    return Container(
      height: 48,
      margin: EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 32),
      child: OutlinedButton(
        onPressed: _phoneController.text.length > 0
            ? () {
                if (_isAgree) {
                  onLogin(bloc);
                } else {
                  BotToast.showText(
                      text: '请先阅读并同意相关协议', align: Alignment.center);
                }
              }
            : null,
        style: ButtonStyle(
          padding:
          MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 13)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xFFFFF5D7);
            }
            return Constants.THEME_COLOR_MAIN;
          }),
          side: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(color: Color(0xFFFFF5D7));
            }
            return BorderSide(color: Constants.THEME_COLOR_MAIN);
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Color(0xFF999999);
            }
            return Color(0xFF222222);
          }),
        ),
        child: Text(
          _isPasswordLogin ? '登录' : '验证码登录',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  ///切换登录方式
  void _switchLoginType() {
    setState(() {
      _isPasswordLogin = !_isPasswordLogin;
    });
    if (_isPasswordLogin) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    } else {
      FocusScope.of(context).requestFocus(_smsFocusNode);
    }
    if (_isPasswordLogin) {
      _passwordFocusNode.requestFocus();
    } else {
      _smsFocusNode.requestFocus();
    }
  }

  Future<bool> validatePhone() async {
    String result = "";
    bool isExist = false;

    if (_phoneController.text == '') {
      result = '';
      BotToast.showText(text: '请输入手机号');
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
    return isExist;
  }

  void doLogin(UserBLoC bloc) async {
    Function cancelFunc = BotToast.showLoading();
    LoginResult result;
    if (_isPasswordLogin) {
      result = await bloc.login(
          username: _phoneController.text,
          password: _passwordController.text,
          remember: _isRemember);
    } else {
      result = await bloc.loginByAuthorizationCode(
          code: _smsCaptchaController.text, remember: _isRemember);
    }
    cancelFunc.call();
    if (result == LoginResult.SUCCESS) {
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    } else {
      BotToast.showText(
        text: _isPasswordLogin ? '账号或密码错误' : '验证码错误',
        align: Alignment.center,
        duration: Duration(seconds: 3),
        clickClose: true,
      );
    }
  }

  void onLogin(UserBLoC bloc) async {
    if (_phoneController.text.length < 11) {
      BotToast.showText(text: '手机号码格式错误');
      throw Exception('手机号码格式错误');
    }
    if (_isPasswordLogin) {
      doLogin(bloc);
    } else {
      Function cancelFunc = BotToast.showLoading();
      BaseResponse baseResponse =
      await UserRepositoryImpl.loginByCaptcha(_phoneController.text);
      cancelFunc.call();
      if (baseResponse == null) {
        BotToast.showText(text: '未知错误');
      } else {
        if (baseResponse.code == 0)
          BotToast.showText(text: '${baseResponse.msg}');
        else
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CodeLoginPage(
                    accountNum: baseResponse.data,
                    phone: _phoneController.text,
                  )));
      }
    }
  }

  void showSnackBar(BuildContext context) {
    if (widget.snackBarMessage != null && widget.snackBarMessage != '') {
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Text('${widget.snackBarMessage}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  ///记录账户
  void checkLocalUserName() async {
    // 检测本地登录过的账户
    String oldUserName = await LocalStorage.get(GlobalConfigs.USER_KEY);

    if (oldUserName != null && oldUserName.isNotEmpty) {
      setState(() {
        _phoneController.text = oldUserName;
      });
    }
  }

  void showPayProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/paymentProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '钉单货款代收代付服务协议',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void showServiceProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/serviceProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '钉单平台服务协议',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  void showPrivacyProtocol() {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString("packages/assets/document/privacyProtocol.txt"),
            initialData: null,
            builder: (context, snapshot) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            '隐私政策声明',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      snapshot.data != null
                          ? Text(snapshot.data)
                          : Center(child: CircularProgressIndicator())
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}

class InputRow extends StatelessWidget {
  final String label;

  final Widget leading;

  final TextField field;

  final Widget surfix;

  final bool isRequired;

  final double labelWidth;

  const InputRow(
      {Key key,
      this.label,
      this.field,
      this.surfix,
      this.leading,
      this.labelWidth = 85,
      this.isRequired = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          label != null
              ? Container(
                  width: labelWidth,
                  child: RichText(
                    text: TextSpan(
                      text: label,
                      style: const TextStyle(
                          color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: isRequired ? ' *' : '',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          leading != null ? leading : Container(),
          Expanded(
            flex: 1,
            child: field,
          ),
          surfix ?? Container()
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.65);
    p.arcToPoint(
      Offset(0.0, size.height * 0.65),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
