import 'dart:async';

import 'package:b2b_commerce/src/home/account/login_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///第三方授权后绑定注册页(注册并绑定第三方)
class RegisterChannelPage extends StatefulWidget {
  final String channelCode;

  const RegisterChannelPage({this.channelCode}) : super();

  _RegisterChannelPageState createState() => _RegisterChannelPageState();
}

class _RegisterChannelPageState extends State<RegisterChannelPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  UserType userType;

  bool _isAgree = false;
  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  bool validate = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _hasReadBrand = false;
  bool _hasReadFactory = false;

  String phoneValidateStr = "";
  String passwordValidateStr = "";

  ///参数填入埋点是否已提交
  bool _formEventTracked = false;

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
                          '渠道编号:${widget.channelCode}',
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
                  _buildProtocolArea(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      onPressed: () => onNext(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Color.fromRGBO(255, 214, 12, 1),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '注册',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
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
      child: Image.asset(
        'temp/login_logo.png',
        package: 'assets',
        width: 100.0,
        height: 100.0,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20.0, 25, 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    userType = UserType.BRAND;
                  });
                },
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Radio(
                        groupValue: userType,
                        value: UserType.BRAND,
                        onChanged: (val) {
                          setState(() {
                            userType = val;
                          });
                          if (!_hasReadBrand) {
                            showSureMessage(context);
                            _hasReadBrand = true;
                          }
                        },
                      ),
                      Text('${UserTypeLocalizedMap[UserType.BRAND]}'),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    userType = UserType.FACTORY;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        groupValue: userType,
                        value: UserType.FACTORY,
                        onChanged: (val) {
                          setState(() {
                            userType = val;
                          });
                          if (!_hasReadFactory) {
                            showSureMessage(context);
                            _hasReadFactory = true;
                          }
                        },
                      ),
                      Text('${UserTypeLocalizedMap[UserType.FACTORY]}'),
                    ],
                  ),
                ),
              )
            ],
          ),
          GestureDetector(
              onTap: () {
                showMessage(context);
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        '如何选择身份',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(
                      B2BIcons.question,
                      color: Colors.red,
                      size: 18,
                    ),
                  ],
                ),
              )),
          InputRow(
            label: '账        号',
            isRequired: true,
            field: TextField(
              autofocus: false,
              onChanged: (value) async {
                formValidate();
              },
              keyboardType: TextInputType.phone,
              //只能输入数字
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _phoneController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: '请输入手机号码'),
            ),
            surfix: Container(
              child: Text(
                phoneValidateStr,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          InputRow(
            label: '验  证  码',
            isRequired: true,
            field: TextField(
              autofocus: false,
              onChanged: (value) {
                formValidate();
              },
              keyboardType: TextInputType.phone,
              //只能输入数字
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4)
              ],
              controller: _captchaController,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: '请输入验证码'),
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
              label: '联  系  人',
              isRequired: true,
              field: TextField(
                autofocus: false,
                onChanged: (value) {
                  formValidate();
                },
                controller: _contactPersonController,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入联系人名字'),
              )),
          InputRow(
            label: '公司名称',
            isRequired: true,
            field: TextField(
              autofocus: false,
              onChanged: (value) {
                formValidate();
              },
              controller: _nameController,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: '请输入公司名称'),
            ),
          ),
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
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: showServiceProtocol,
                    child: Text(
                      '《钉单平台服务协议》',
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Text(
                    '和',
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: showPayProtocol,
                    child: Text(
                      '《钉单平台货款代收代付服务协议》',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  GestureDetector(
                    onTap: showPrivacyProtocol,
                    child: Text(
                      '《隐私协议》',
                      style: TextStyle(color: Colors.blue),
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
        UserType type =
            await UserRepositoryImpl().phoneExist(_phoneController.text);

        if (type != null && type != UserType.DEFAULT) {
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

  ///表单校验
  void formValidate() {
    //埋点判断
    _formEventTrack();
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
          _nameController.text.trim().length > 0 &&
          _contactPersonController.text.trim().length > 0 &&
          userType != null &&
          _isAgree;
    });
  }

  void onNext(BuildContext context) async {
    bool result = await UserRepositoryImpl()
        .validateCaptcha(_phoneController.text, _captchaController.text);
    if (result) {
      if (!RegexUtil.isMobile(_phoneController.text)) {
        //验证账号
        showValidateDialog(context, '请输入正确手机号码');
      } else if (_contactPersonController.text.length < 1) {
        //验证联系人
        showValidateDialog(context, '请输入联系人名字');
      } else if (_nameController.text.length < 1) {
        //验证公司名字
        showValidateDialog(context, '请输入公司名称');
      } else if (!_isAgree) {
        showValidateDialog(context, '请先同意《钉单平台服务协议》和《钉单平台贷款代收代付服务协议》');
      } else if (userType != UserType.BRAND && userType != UserType.FACTORY) {
        showValidateDialog(context, '请选择注册类型');
      } else {
        onSubmit();
      }
    } else {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '验证不正确',
              callbackResult: false,
              confirmAction: () {
                Navigator.of(context).pop();
              },
            );
          });
//      (_scaffoldKey.currentState)
//          .showSnackBar(SnackBar(content: Text('验证不正确')));
    }
  }

  void onSubmit() async {
    var cancelFunc = BotToast.showLoading(
      clickClose: true,
      crossPage: false,
    );

    CompanyRegisterDTO form = CompanyRegisterDTO();
    form
      ..name = _nameController.text
      ..contactPerson = _contactPersonController.text
      ..contactPhone = _phoneController.text
      ..mobileNumber = _phoneController.text
      ..captchaCode = _captchaController.text;

    //TODO:渠道码

    BaseResponse response = await UserRepositoryImpl()
        .bindingRegister(type: UserTypeMap[userType], form: form);

    if (response != null) {
      //注册成功
      //埋点>>>用户注册-成功
      UmengPlugin.onEvent(
        'user_register_success',
      );

      //授权码登录
      UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);
      bloc
          .loginByAuthorizationCode(code: response.data, remember: true)
          .then((result) {
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        }
      });
    } else {
      cancelFunc.call();
      showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (context) {
          return AlertDialog(
            title: Text('注册失败'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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

  void showMessage(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      '如何选择用户身份类型',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: '品牌商：',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '服装品牌商、贴牌贸易商、设计工作室、批发档口、电商网红等，需要在钉单APP寻找优质工厂或者服装款式服务的企业或个人，选择“品牌商”注册。',
                            style: TextStyle(color: Colors.black))
                      ]),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: RichText(
                    text: TextSpan(
                        text: '工 厂：',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  '服装生产工厂，需要在钉单APP上寻找各类服装加工订单，管理生产进度的企业选择“工厂”注册。',
                              style: TextStyle(color: Colors.black))
                        ]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text('我知道了'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showSureMessage(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: RichText(
                    text: TextSpan(
                        text: '您当前选择的是"',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${UserTypeLocalizedMap[userType]}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                          TextSpan(
                            text: '" 身份注册，',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: '一经注册不能更改!',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                        ]),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text('我知道了'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void showValidateDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '$message',
            callbackResult: false,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  ///用户是否填入参数
  void _formEventTrack() {
    if (!_formEventTracked) {
      if (_phoneController.text != "" ||
          _captchaController.text != "" ||
          _contactPersonController.text != "" ||
          _nameController.text != "") {
        //注册填写
        //埋点>>>用户注册-用户填写过参数
        UmengPlugin.onEvent('user_register_form_input');
        setState(() {
          _formEventTracked = true;
        });
      }
    }
  }
}
