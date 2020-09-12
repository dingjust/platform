import 'dart:async';

import 'package:b2b_commerce/src/home/account/login_page.dart';
import 'package:b2b_commerce/src/my/my_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class BindingCardPage extends StatefulWidget {
  @override
  _BindingCardPageState createState() => _BindingCardPageState();
}

class _BindingCardPageState extends State<BindingCardPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _bankBranchController = TextEditingController();
  TextEditingController _cardController = TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _cardFocusNode = FocusNode();
  FocusNode _bankBranchFocusNode = FocusNode();

  BankResponse bank;

  String _verifyStr = '获取验证码';
  int _seconds = 0;
  Timer _timer;
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('绑定银行卡'),
      ),
      body: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                focusNode: _nameFocusNode,
                controller: _nameController,
                leadingText: Text('户名',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '输入',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                onChanged: (val) {},
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                focusNode: _cardFocusNode,
                controller: _cardController,
                inputType: TextInputType.number,
                leadingText: Text('银行卡号',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '输入',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
                onChanged: (val) {
                  onCardNoInput(val);
                },
              ),
            ),
            bank != null
                ? Container(
              color: Colors.white,
              height: 100,
              padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: '银行：',
                        style:
                        TextStyle(fontSize: 16, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: bank?.bankName ?? '')
                        ]),
                  ),
                  bank != null
                      ? Image.network(Apis.cnBankLOGO(bank.bank))
                      : Container(),
                ],
              ),
            )
                : Container(
              color: Colors.white,
              height: 100,
              child: InputRow(
                field: TextField(
                  autofocus: false,
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      hintText: '请输入银行名称', border: InputBorder.none),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: TextFieldComponent(
                focusNode: _bankBranchFocusNode,
                controller: _bankBranchController,
                leadingText: Text('开户网点',
                    style: TextStyle(
                      fontSize: 16,
                    )),
                hintText: '输入',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              color: Colors.white,
              child: InputRow(
                field: TextField(
                  autofocus: false,
                  onChanged: (value) {
                    // formValidate();
                  },
                  keyboardType: TextInputType.phone,
                  //只能输入数字
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  controller: _captchaController,
                  decoration: InputDecoration(
                      hintText: '请输入验证码', border: InputBorder.none),
                ),
                surfix: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  color: Color.fromRGBO(255, 214, 12, 1),
                  onPressed: (_seconds == 0)
                      ? () async {
                    UserRepositoryImpl()
                        .sendCaptcha(
                        UserBLoC.instance.currentUser.mobileNumber)
                        .then((a) {
                      _startTimer();
                    });
                        }
                      : null,
                  child: Text(
                    '$_verifyStr',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text(
                      sent
                          ? '验证码已发送到手机${UserBLoC.instance.currentUser.mobileNumber.substring(0, 3)}****${UserBLoC.instance.currentUser.mobileNumber.substring(7, 11)}'
                          : '',
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: RaisedButton(
          color: const Color.fromRGBO(255, 219, 0, 1),
          child: Text(
            '确认绑定',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            onSubmit();
          },
        ),
      ),
    );
  }

  Future<void> onCardNoInput(String val) async {
    if (val.length > 10) {
      BankResponse result = await BankService().getCardInfo(val);
      setState(() {
        if (result.validated) {
          bank = result;
        } else {
          bank = null;
        }
      });
    }
  }

  void onSubmit() async {
    bool result = await UserRepositoryImpl().validateCaptcha(
        UserBLoC.instance.currentUser.mobileNumber, _captchaController.text);
    if (result) {
      BankCardModel form = BankCardModel();
      form
        ..accountName = _nameController.text
        ..cardNumber = _cardController.text
        ..bankOutlet = _bankBranchController.text;

      if (bank != null) {
        form
          ..iconUrl = Apis.cnBankLOGO(bank.bank)
          ..bankCode = bank.bank
          ..bankName = bank.bankName;
      } else {
        form..bankName = _bankNameController.text;
      }

      BankCardRepository().bindingBankCard(form).then((result) {
        if (result) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: result ? '绑定成功' : '绑定失败',
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => MyAccountPage()),
                        ModalRoute.withName('/'));
                  },
                );
              });
        }
      });
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
    }
  }

  _startTimer() {
    _seconds = 60;
    sent = true;

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
}
