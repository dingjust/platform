import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.logo);

  final Image logo;

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> registrationKey = GlobalKey();

  String _phoneNum = '';

  String _verifyCode = '';

  int _seconds = 0;

  String _verifyStr = '获取验证码';

  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  _startTimer() {
    _seconds = 10;

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

  Widget _buildPhoneEdit() {
    var node = FocusNode();
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0),
      child: TextField(
        onChanged: (str) {
          _phoneNum = str;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: '请输入手机号',
        ),
        maxLines: 1,
        maxLength: 11,
        //键盘展示为号码
        keyboardType: TextInputType.phone,
        //只能输入数字
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        onSubmitted: (text) {
          FocusScope.of(context).reparentIfNeeded(node);
        },
      ),
    );
  }

  Widget _buildVerifyCodeEdit() {
    var node = FocusNode();
    Widget verifyCodeEdit = TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: '请输入短信验证码',
      ),
      maxLines: 1,
      maxLength: 6,
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (text) {
        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    Widget verifyCodeBtn = InkWell(
      onTap: (_seconds == 0)
          ? () {
              setState(() {
                _startTimer();
              });
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 36.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        child: Text(
          '$_verifyStr',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      child: Stack(
        children: <Widget>[
          verifyCodeEdit,
          Align(
            alignment: Alignment.topRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 40.0, bottom: 20.0),
      alignment: Alignment.center,
      child: widget.logo,
    );
  }

  Widget _buildRegistration() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        disabledColor: Colors.blue[100],
        onPressed: (_phoneNum.isEmpty || _verifyCode.isEmpty)
            ? null
            : () {
                showTips();
              },
        child: Text(
          "登  录",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildTips() {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //子组件的排列方式为主轴两端对齐
        children: <Widget>[
          Text(
            "未注册手机验证后自动登录",
            style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
          ),
          Text(
            "需要帮助",
            style: TextStyle(fontSize: 14.0, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ListView(
      children: <Widget>[
        _buildLogo(),
        _buildPhoneEdit(),
        _buildVerifyCodeEdit(),
        _buildRegistration(),
        _buildTips(),
      ],
    );
  }

  showTips() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text('没有相关接口，这是一个纯UI界面，提供部分交互体验',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24.0))));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        key: registrationKey,
        backgroundColor: Colors.white,
        body: _buildBody(),
      ),
    );
  }
}
