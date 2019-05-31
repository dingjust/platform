import 'dart:async';

import 'package:b2b_commerce/main.dart';
import 'package:b2b_commerce/src/home/index.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart'
    show LoginResult, UserBLoC, UserRepositoryImpl;
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';
import 'package:widgets/widgets.dart';

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

  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  String phoneValidateStr = "";

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = true;
  bool validate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocalUserName());
  }

  @override
  Widget build(BuildContext context) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    bloc.loginStream.listen((result) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '${result}',
              callbackResult: false,
            );
          }).then((_) {
        Navigator.of(context).pop();
      });
//      showDialog(
//          context: context,
//          child: SimpleDialog(
//            title: Text('登陆失败'),
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(10),
//                child: Text('${result}'),
//              ),
//            ],
//          ));
    });

    return Material(
      child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: _formKey,
            autovalidate: true,
            child: _buildBody(context, bloc),
          )),
    );
  }

  _startTimer() {
    _seconds = 60;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  Widget _buildServiceRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordLogin = !_isPasswordLogin;
              });
            },
            child: Text(
              _isPasswordLogin ? '验证码登陆' : '密码登陆',
              style: TextStyle(fontSize: 15),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => widget.registerPage));
            },
            child: Container(
              child: Text(
                '注册',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    //监听密码输入变动、刷新表单校验
    _passwordController.addListener(() {
      setState(() {});
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          InputRow(
            leading: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Icon(
                Icons.phone_iphone,
                color: Colors.grey,
              ),
            ),
            field: TextField(
              autofocus: false,
              onChanged: (value) async {
                formValidate();
              },
              keyboardType: TextInputType.phone,
              //只能输入数字
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              controller: _phoneController,

              decoration:
                  InputDecoration(hintText: '请输入', border: InputBorder.none),
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
                Text(
                  phoneValidateStr,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            )),
          ),
          _isPasswordLogin
              ? InputRow(
                  leading: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Container(
                      child: Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  field: TextField(
                    autofocus: false,
                    obscureText: _isPasswordHide,
                    onChanged: (value) {
                      formValidate();
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: '请输入', border: InputBorder.none),
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
              : InputRow(
                  leading: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Icon(
                      Icons.sms,
                      color: Colors.grey,
                    ),
                  ),
                  field: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      formValidate();
                    },
                    keyboardType: TextInputType.phone,
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    controller: _smsCaptchaController,
                    decoration: InputDecoration(
                        hintText: '请输入', border: InputBorder.none),
                  ),
                  surfix: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    color: Color.fromRGBO(255, 214, 12, 1),
                    onPressed: (_seconds == 0)
                        ? () async {
                            bool legal = await validatePhone();
                            if (legal) {
                              UserRepositoryImpl()
                                  .sendCaptchaForLogin(_phoneController.text)
                                  .then((a) {
                                _startTimer();
                              });
                            }
                          }
                        : null,
                    child: Text(
                      '$_verifyStr',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => widget.forgetPasswordPage));
                },
                child: Text(
                  '忘记密码',
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '记住账号',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  Checkbox(
                    onChanged: (v) {
                      setState(() {
                        _isRemember = v;
                      });
                    },
                    activeColor: Colors.orange,
                    value: _isRemember,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(255, 214, 12, 1)),
        padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 20.0),
        child: widget.logo);
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                onPressed: (_formKey.currentState as FormState) == null
                    ? null
                    : (_formKey.currentState as FormState).validate()
                        ? () {
                            onLogin(bloc);
                          }
                        : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Color.fromRGBO(255, 214, 12, 1),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '登录',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
            _buildServiceRow()
          ])),
        ],
      ),
    );
  }

  void formValidate() {
    if (!RegexUtil.isMobile(_phoneController.text)) {
      setState(() {
        phoneValidateStr = '输入正确手机号';
      });
    } else {
      setState(() {
        phoneValidateStr = '';
      });
    }
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
    } else {
      if (RegexUtil.isMobile(_phoneController.text)) {
        bool exist =
            await UserRepositoryImpl().phoneExist(_phoneController.text);

        if (exist != null && exist) {
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

  doLogin(UserBLoC bloc) {}

  void onLogin(UserBLoC bloc) {
//    //加载条
//    showDialog(
//      context: context,
//      builder: (context) =>
//          ProgressIndicatorFactory.buildDefaultProgressIndicator(),
//    );
    if (_isPasswordLogin) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: bloc.login(
                  username: _phoneController.text,
                  password: _passwordController.text,
                  remember: _isRemember),
              loadingText: '登录中。。。',
              entrance: '',
            );
          }).then((result) {
        print(result);
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      MyAppHomeDelegate(
                          userType: UserBLoC.instance.currentUser.type)),
              ModalRoute.withName('/'));
//          Navigator.pop(context);
//          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        } else if (result == LoginResult.DIO_ERROR) {
          Navigator.of(context).pop();
        }
      });
//      bloc
//          .login(
//              username: _phoneController.text,
//              password: _passwordController.text,
//              remember: _isRemember)
//          .then((result) {
//        if (result == LoginResult.SUCCESS) {
//          Navigator.of(context).popUntil(ModalRoute.withName('/'));
//        } else if (result == LoginResult.DIO_ERROR) {
//          Navigator.of(context).pop();
//        }
//      });
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: bloc.loginByCaptcha(
                  username: _phoneController.text,
                  captcha: _smsCaptchaController.text,
                  remember: _isRemember),
              outsideDismiss: false,
              loadingText: '登录中。。。',
              entrance: '',
            );
          }).then((result) {
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              ModalRoute.withName('/'));
//          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        } else if (result == LoginResult.DIO_ERROR) {
          Navigator.of(context).pop();
        }
      });
//      bloc
//          .loginByCaptcha(
//              username: _phoneController.text,
//              captcha: _smsCaptchaController.text,
//              remember: _isRemember)
//          .then((result) {
//        if (result == LoginResult.SUCCESS) {
//          Navigator.of(context).popUntil(ModalRoute.withName('/'));
//        } else if (result == LoginResult.DIO_ERROR) {
//          Navigator.of(context).pop();
//        }
//      });
    }
  }

  void showSnackBar(BuildContext context) {
    if (widget.snackBarMessage != null && widget.snackBarMessage != '') {
      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
        SnackBar(
          content: Text('${widget.snackBarMessage}'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  ///记录账户
  void checkLocalUserName() async {
    // 检测本地登陆过的账户
    String oldUserName = await LocalStorage.get(GlobalConfigs.USER_KEY);

    if (oldUserName != null && oldUserName.isNotEmpty) {
      setState(() {
        _phoneController.text = oldUserName;
      });
    }
  }
}

class InputRow extends StatelessWidget {
  final String label;

  final Widget leading;

  final TextField field;

  final Widget surfix;

  final bool isRequired;

  const InputRow({Key key,
    this.label,
    this.field,
    this.surfix,
    this.leading,
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
                  width: 100,
                  child: Text(
                    label,
                    style: TextStyle(
                        color: Color.fromRGBO(36, 38, 41, 1), fontSize: 18),
                  ),
                )
              : Container(),
          isRequired
              ? Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          )
              : Container(
            margin: EdgeInsets.only(right: 20),
          ),
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
