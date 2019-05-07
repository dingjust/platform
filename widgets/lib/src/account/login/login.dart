import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart' show UserBLoC;
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

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _smsCaptchaController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();

  bool _isRemember = true;
  bool _isPasswordHide = true;
  bool _isPasswordLogin = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showSnackBar(context));
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLocalUserName());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: _formKey,
            autovalidate: true,
            child: _buildBody(context),
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
              _isPasswordLogin ? '验证码登录' : '密码登录',
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
    TextFormField _passwordField = TextFormField(
        autofocus: false,
        controller: _passwordController,
        obscureText: _isPasswordHide,
        decoration: InputDecoration(
            hintText: '请输入密码',
            errorStyle: TextStyle(fontSize: 0),
            focusedErrorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
            errorBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
            border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
            suffix: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => widget.forgetPasswordPage));
              },
              child: Text(
                '忘记密码',
                style: TextStyle(color: Colors.black54, fontSize: 15),
              ),
            )),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '';
        });

    TextFormField _smsCaptchaField = TextFormField(
        autofocus: false,
        controller: _smsCaptchaController,
        decoration: InputDecoration(
          hintText: '请输入',
          errorStyle: TextStyle(fontSize: 0),
          focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
          errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 1))),
          suffix: FlatButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: (_seconds == 0)
                ? () {
                    setState(() {
                      _startTimer();
                    });
                  }
                : null,
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '$_verifyStr',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        // 校验用户名
        validator: (v) {
          return v.trim().length > 0 ? null : '';
        });

    //监听密码输入变动、刷新表单校验
    _passwordController.addListener(() {
      setState(() {});
    });

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                padding: EdgeInsets.only(top: 25),
                child: Icon(
                  Icons.phone_iphone,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    //只能输入数字
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        suffix: FlatButton(
                          onPressed: () {
                            setState(() {
                              _phoneController.clear();
                            });
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: '请输入手机号码',
                        errorStyle: TextStyle(fontSize: 0),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 1))),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 1))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 1))),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromRGBO(200, 200, 200, 1)))),
                    // 校验用户名
                    validator: (v) {
                      return v.trim().length > 0 ? null : '';
                    }),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  padding: EdgeInsets.only(top: 25),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordHide = !_isPasswordHide;
                      });
                    },
                    child: _isPasswordLogin
                        ? Icon(
                            _isPasswordHide
                                ? B2BIcons.eye_not_see
                                : Icons.remove_red_eye,
                            color: Colors.black54,
                          )
                        : Container(
                            width: 25,
                          ),
                  )),
              Expanded(
                flex: 1,
                child: _isPasswordLogin ? _passwordField : _smsCaptchaField,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
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

  void onLogin(UserBLoC bloc) {
    //加载条
    showDialog(
      context: context,
      builder: (context) =>
          ProgressIndicatorFactory.buildDefaultProgressIndicator(),
    );
    bloc
        .login(
            username: _phoneController.text,
            password: _passwordController.text,
            remember: _isRemember)
        .then((result) {
      if (result) {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
      }
    });
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
    // 检测本地登录过的账户
    String oldUserName = await LocalStorage.get(GlobalConfigs.USER_KEY);

    if (oldUserName != null && oldUserName.isNotEmpty) {
      setState(() {
        _phoneController.text = oldUserName;
      });
    }
  }
}
