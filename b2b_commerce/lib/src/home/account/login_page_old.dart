import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart'
    show LoginResult, UserBLoC, UserRepositoryImpl, BaseResponse;
import 'package:widgets/widgets.dart';

import 'auth_login.dart';
import 'code_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key key,
    @required this.logo,
    this.registerPage,
    this.forgetPasswordPage,
    this.snackBarMessage,
  }) : super(key: key);

  final Image logo;
  final Widget registerPage;
  final Widget forgetPasswordPage;
  final String snackBarMessage;

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey();

  TextEditingController _phoneController;
  TextEditingController _passwordController;
  TextEditingController _smsCaptchaController;
  FocusNode _passwordFocusNode;
  FocusNode _smsFocusNode;

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = false;
  bool validate = false;
  bool _isAgree = false;

  ///倒计时间
  int countdownTime = 60;
  final CountdownController controller = CountdownController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocalUserName());

    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _smsCaptchaController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _smsFocusNode = FocusNode();

    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    return Material(
      child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: _buildBody(context, bloc),
          )),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          InputRow(
            leading: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_iphone,
                      color: Colors.grey,
                    ),
                    Text(
                      '(+86)',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )),
            field: TextField(
              autofocus: false,
              // maxLength: 11,

              buildCounter: (context,
                      {int currentLength, bool isFocused, int maxLength}) =>
                  null,
              maxLengthEnforced: true,
              onChanged: (value) async {
                formValidate();
              },
              // keyboardType: TextInputType.phone,
              //只能输入数字
              inputFormatters: <TextInputFormatter>[
                // FilteringTextInputFormatter.digitsOnly
              ],
              controller: _phoneController,
              decoration: InputDecoration(
                  hintText: '请输入手机号',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 0)),
            ),
            surfix: Container(
                child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _phoneController.clear();
                  },
                ),
              ],
            )),
          ),
          _isPasswordLogin
              ? InputRow(
                  leading: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 56, 0),
                    child: Container(
                        child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                      ],
                    )),
                  ),
                  field: TextField(
                    autofocus: false,
                    focusNode: _passwordFocusNode,
                    obscureText: _isPasswordHide,
                    onChanged: (value) {
                      formValidate();
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: '请输入密码', border: InputBorder.none),
                  ),
                  surfix: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordHide = !_isPasswordHide;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(
                          _isPasswordHide
                              ? B2BIcons.eye_not_see
                              : Icons.remove_red_eye,
                          color: Colors.black54,
                        ),
                      )))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  setState(() {
                    _isPasswordLogin = !_isPasswordLogin;
                    if (_isPasswordLogin) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    } else {
                      FocusScope.of(context).requestFocus(_smsFocusNode);
                    }
                  });
                  if (_isPasswordLogin) {
                    _passwordFocusNode.requestFocus();
                  } else {
                    _smsFocusNode.requestFocus();
                  }
                },
                child: Text(
                  _isPasswordLogin ? '验证码登录' : '密码登录',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => widget.forgetPasswordPage));
                },
                child: Text(
                  '忘记密码',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(255, 214, 12, 8)),
          padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 20.0),
          child: widget.logo),
    );
  }

  Widget _buildBody(BuildContext context, UserBLoC bloc) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 160.0,
            pinned: true,
            elevation: 0.5,
            leading: Container(),
            brightness: Brightness.light,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _buildLogo(),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            _buildInputArea(),
            _buildProtocolArea(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {
                  if (_isAgree) {
                    onLogin(bloc);
                  } else {
                    BotToast.showText(
                        text: '请先阅读并同意相关协议', align: Alignment.center);
                  }
                },
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 10)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                    backgroundColor:
                        MaterialStateProperty.all(Constants.THEME_COLOR_MAIN),
                    side: MaterialStateProperty.all(
                        BorderSide(color: Constants.THEME_COLOR_MAIN))),
                child: Text(
                  _isPasswordLogin ? '登录' : '获取验证码',
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: OutlinedButton(
            //     onPressed: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => widget.registerPage));
            //     },
            //     style: ButtonStyle(
            //       padding: MaterialStateProperty.all(
            //           EdgeInsets.symmetric(vertical: 10)),
            //       shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(50))),
            //     ),
            //     child: Text(
            //       '注册',
            //       style: TextStyle(color: Colors.black54, fontSize: 18),
            //     ),
            //   ),
            // ),
            OtherAuthLoginBtnGroup(),
          ])),
        ],
      ),
    );
  }

  Widget _buildProtocolArea() {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Row(
          children: <Widget>[
            Checkbox(
              onChanged: (v) {
                setState(() {
                  _isAgree = v;
                  formValidate();
                });
              },
              value: _isAgree,
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.start, //沿主轴方向居中
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    '我已阅读并同意',
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                  GestureDetector(
                    onTap: showServiceProtocol,
                    child: Text(
                      '《钉单平台服务协议》',
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  ),
                  Text(
                    '和',
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                  GestureDetector(
                    onTap: showPrivacyProtocol,
                    child: Text(
                      '《隐私协议》',
                      style: TextStyle(color: Colors.blue, fontSize: 10),
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

  void formValidate() {
    setState(() {
      if (_isPasswordLogin) {
        validate = _phoneController.text.trim().length == 11 &&
            _passwordController.text.trim().length > 0;
      } else {
        validate = _phoneController.text.trim().length == 11 &&
            _smsCaptchaController.text.trim().length > 0;
      }
    });
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
              builder: (context) => CodeLoginPage(
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
