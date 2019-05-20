import 'dart:async';

import 'package:b2b_commerce/src/my/account/register_info.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  final Image logo;

  const RegisterPage({Key key, @required this.logo}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isAgree = false;
  String _userType = "brand";
  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  bool validate = false;
  bool _isPasswordHide = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String phoneValidateStr = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _handleUserTypeChanged(String value) {
    setState(() {
      _userType = value;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 160.0,
                pinned: true,
                elevation: 0.5,
                brightness: Brightness.light,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      _buildLogo(),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: Text(
                          '当前选择:${UserTypeLocalizedMap[UserBLoC.instance.currentUser.type]}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate(
                [
                  _buildInputArea(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: RaisedButton(
                      onPressed: validate ? () => onNext(context) : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Color.fromRGBO(255, 214, 12, 1),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '下一步',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  _buildProtocolArea()
                ],
              )),
            ],
          ),
        ));
  }

  Widget _buildLogo() {
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(255, 214, 12, 1)),
        padding: const EdgeInsets.fromLTRB(0, 60.0, 0, 20.0),
        child: widget.logo);
  }

  Widget _buildInputArea() {
    return Container(
      margin: EdgeInsets.only(bottom: 50),
      padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
      child: Column(
        children: <Widget>[
          InputRow(
            // label: '手机号',
            leading: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              // padding: EdgeInsets.only(top: 25),
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
              child: Text(
                phoneValidateStr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          InputRow(
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
              controller: _captchaController,
              decoration:
                  InputDecoration(hintText: '请输入', border: InputBorder.none),
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
                            .sendCaptcha(_phoneController.text)
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
          InputRow(
            leading: Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Container(
                  child: Icon(
                    Icons.lock,
                    color: Colors.grey,
                  ),
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
              decoration:
                  InputDecoration(hintText: '请输入', border: InputBorder.none),
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
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolArea() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                    '已经阅读或同意',
                    style: TextStyle(
                        color: _isAgree
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.black54),
                  ),
                  GestureDetector(
                      onTap: showServiceProtocol,
                      child: Container(
                        child: Text(
                          '《钉单平台服务协议》',
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: _isAgree
                                  ? Color.fromRGBO(255, 214, 12, 1)
                                  : Colors.blue),
                        ),
                      )),
                  Text(
                    '和',
                    style: TextStyle(
                        color: _isAgree
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.black54),
                  ),
                  GestureDetector(
                    onTap: showPayProtocol,
                    child: Text(
                      '《钉单平台货款代收代付服务协议》',
                      style: TextStyle(
                          color: _isAgree
                              ? Color.fromRGBO(255, 214, 12, 1)
                              : Colors.blue),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<bool> validatePhone() async {
    String result = "";
    bool legal = false;

    if (_phoneController.text == '' || _phoneController.text == null) {
      result = '输入正确手机号';
    } else {
      if (RegexUtil.isMobile(_phoneController.text)) {
        bool exist =
            await UserRepositoryImpl().phoneExist(_phoneController.text);

        if (exist != null && exist) {
          result = "账号已存在";
        } else {
          result = "";
          legal = true;
        }
      } else {
        result = "输入正确手机号";
      }
    }

    setState(() {
      phoneValidateStr = result;
    });

    return legal;
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
      validate = _phoneController.text.trim().length > 0 &&
          _captchaController.text.trim().length > 0 &&
          _passwordController.text.trim().length > 0 &&
          _isAgree;
    });
  }

  void onNext(BuildContext context) async {
    bool result = await UserRepositoryImpl()
        .validateCaptcha(_phoneController.text, _captchaController.text);
    if (result) {
      //TODOS验证验证码
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RegisterInfoPage(
                phone: _phoneController.text,
                password: _passwordController.text,
              )));
    } else {
      (_scaffoldKey.currentState)
          .showSnackBar(SnackBar(content: Text('验证不正确')));
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
}

class UserTypeEntry {
  final String label;
  final String value;
  final Icon icon;

  UserTypeEntry({this.label, this.value, this.icon});
}

class UserTypeSelector extends StatelessWidget {
  const UserTypeSelector(
      {Key key, @required this.value, this.userTypeEntries, this.onChanged})
      : super(key: key);

  final String value;
  final List<UserTypeEntry> userTypeEntries;

  final ValueChanged<String> onChanged;

  void _handleTap(String v) {
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = userTypeEntries
        .map((v) => GestureDetector(
              onTap: () {
                _handleTap(v.value);
              },
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: v.icon,
                    ),
                    Text(
                      v.label,
                      style: TextStyle(
                          color: v.value == value
                              ? Color.fromRGBO(255, 214, 12, 1)
                              : Colors.black54),
                    )
                  ],
                ),
              ),
            ))
        .toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widgetList,
    );
  }
}

class RegisterInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String remind;
  final bool validate;

  const RegisterInput(
      {Key key,
      @required this.controller,
      @required this.labelText,
      @required this.remind,
      this.validate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
      child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
              labelText: labelText, hintText: '请输入', border: InputBorder.none),
          // 校验用户名
          validator: (v) {
            if (validate) {
              return v.trim().length > 0 ? null : remind;
            } else {
              return null;
            }
          }),
    );
  }
}
