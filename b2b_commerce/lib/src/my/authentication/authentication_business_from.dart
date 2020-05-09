import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class AuthenticationBusinessFromPage extends StatefulWidget {
  _AuthenticationBusinessFromPageState createState() =>
      _AuthenticationBusinessFromPageState();
}

class _AuthenticationBusinessFromPageState
    extends State<AuthenticationBusinessFromPage> {
  FocusNode _enterpriseNameFocusNode = FocusNode();
  FocusNode _xydmFocusNode = FocusNode();
  FocusNode _fddbrFocusNode = FocusNode();
  FocusNode _idCardFocusNode = FocusNode();
  TextEditingController _enterpriseNameController = TextEditingController();
  TextEditingController _xydmController = TextEditingController();
  TextEditingController _fddbrController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  String type;
  String typeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('个体户认证'),
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
          if (_enterpriseNameController == null ||
              _enterpriseNameController.text == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '公司名称不能为空',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else if (_xydmController == null || _xydmController.text == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '信用代码不能为空',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else if (_fddbrController == null || _fddbrController.text == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '法定代表人不能为空',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else if (_idCardController == null ||
              _idCardController.text == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '身份证号码不能为空',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else if (type == null || type == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '请选择身份',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else if (type == null || type == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '请选择认证方式',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          } else {
            Map map = {
              'companyName': _enterpriseNameController.text,
              'organization': _xydmController.text,
              'role': 'LEGAL',
              'username': _fddbrController.text,
              'idCardNum': _idCardController.text,
              'verifyWay': type,
              'companyType': 'TYPE2'
            };
            enterprise(map);
          }
        },
      ),
    );
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
              child: Text('企业信息'),
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _enterpriseNameFocusNode,
              controller: _enterpriseNameController,
              leadingText: Text('公司名称',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入公司全称',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _xydmFocusNode,
              controller: _xydmController,
              leadingText: Text('信用代码',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入社会统一信用代码',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _fddbrFocusNode,
              controller: _fddbrController,
              leadingText: Text('法定代表人',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入法人姓名',
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            color: Colors.grey[100],
          ),
          GestureDetector(
            onTap: () {
              _showTypeSelect();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('认证方式',
                          style: TextStyle(
                            fontSize: 16,
                          )),
                    ),
                  ),
                  Container(
                    child: Text('${type != null ? type : '选择认证方式'}',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTypeSelect() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('对公账号认证'),
                  onTap: () async {
                    setState(() {
                      typeName = '对公账号认证';
                      type = 'WAY1';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('无对公账号认证'),
                  onTap: () async {
                    setState(() {
                      typeName = '无对公账号认证';
                      type = 'WAY2';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  enterprise(Map map) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ContractRepository().enterpriseAuthentication(map),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
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
}
