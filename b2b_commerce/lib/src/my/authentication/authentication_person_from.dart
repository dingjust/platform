import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/my/contract/webview_page.dart';
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
          child: ListView(
            children: <Widget>[
              _buildEnterpriseInfo(),
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
            personal(_fddbrController.text, _idCardController.text);
          }
        },
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
      print(certification.msg);
      if (certification != null) {
        if (certification.data != null) {
//          _launchURL(certification.data);
          Navigator.push(
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
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[100],
            child: Center(
              child: Text('身份信息'),
            ),
          ),
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
}
