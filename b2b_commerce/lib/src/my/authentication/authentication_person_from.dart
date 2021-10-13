import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class AuthenticationPersonFromPage extends StatefulWidget {
  _AuthenticationPersonFromPageState createState() =>
      _AuthenticationPersonFromPageState();
}

class _AuthenticationPersonFromPageState
    extends State<AuthenticationPersonFromPage> {
  FocusNode _fddbrFocusNode = FocusNode();
  FocusNode _idCardFocusNode = FocusNode();
  TextEditingController _fddbrController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('个人认证'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _buildEnterpriseInfo(),
              _buildWarning(),
              _buildWarningInfo()
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButton());
  }

  Widget _buildBottomButton() {
    return Container(
      color: Colors.white10,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      height: 50,
      child: RaisedButton(
        color: Color.fromRGBO(255, 214, 12, 1),
        child: Text(
          '提交认证',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        onPressed: () {
          if (_fddbrController != null &&
              _fddbrController.text != null &&
              _fddbrController.text != '' &&
              _idCardController != null &&
              _idCardController.text != null &&
              _idCardController.text != '') {
            showAgreeDialog();
          } else {
            BotToast.showText(text: '请填写信息');
          }
        },
      ),
    );
  }

  Widget _buildWarning() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            '填写身份证上的真实信息',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ))
        ],
      ),
    );
  }

  Widget _buildWarningInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            '$AUTHENTICATION_INFO',
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }

  personal(String name, String idCard) {
    Map map = {
      'username': name,
      'idCardNum': idCard,
    };
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ContractRepository().personalAuthentication(map),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
//          _launchURL(certification.data);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '认证失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  Widget _buildEnterpriseInfo() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _fddbrFocusNode,
              controller: _fddbrController,
              leadingText: Text('姓名',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入个人姓名',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _idCardFocusNode,
              controller: _idCardController,
              leadingText: Text('身份证号码',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入身份证号码',
              hideDivider: true,
            ),
          ),
        ],
      ),
    );
  }

  ///授权提示
  void showAgreeDialog() {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      crossPage: false,
      toastBuilder: (cancelFunc) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            content: Text('您将前往“法大大”申请数字证书，数字证书申请需要调用系统相机、相册的功能授权，您是否同意？'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  cancelFunc.call();
                },
                child: const Text(
                  '拒绝',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  cancelFunc.call();
                  PermissionHelper.checkCameraAndPhoto().then((value) {
                    if (value) {
                      personal(_fddbrController.text, _idCardController.text);
                    }
                  });
                },
                child: const Text(
                  '同意',
                  style: TextStyle(color: Colors.lightBlue),
                ),
              ),
            ],
          ),
    );
  }
}

///认证提示信息
const AUTHENTICATION_INFO = '个人信息一旦认证完成不可以变更';
