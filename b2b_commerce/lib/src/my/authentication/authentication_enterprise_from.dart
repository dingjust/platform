import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class AuthenticationEnterpriseFromPage extends StatefulWidget {
  final AuthenticationInfoModel model;

  const AuthenticationEnterpriseFromPage({Key key, this.model})
      : super(key: key);

  _AuthenticationEnterpriseFromPageState createState() =>
      _AuthenticationEnterpriseFromPageState();
}

class _AuthenticationEnterpriseFromPageState
    extends State<AuthenticationEnterpriseFromPage> {
  FocusNode _enterpriseNameFocusNode = FocusNode();
  FocusNode _xydmFocusNode = FocusNode();
  FocusNode _fddbrFocusNode = FocusNode();
  TextEditingController _enterpriseNameController = TextEditingController();
  TextEditingController _xydmController = TextEditingController();
  TextEditingController _fddbrController = TextEditingController();
  String _roleStr = '';

  @override
  void initState() {
    super.initState();
    if (widget.model != null) {
      _enterpriseNameController.text = widget.model.name ?? '';
      _xydmController.text = widget.model.organization ?? '';
      _fddbrController.text = widget.model.legal?.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('企业认证'),
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
          if (_enterpriseNameController == null ||
              _enterpriseNameController.text == '') {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '企业名称不能为空',
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
          } else if (_roleStr == null || _roleStr == '') {
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
          } else {
            showAgreeDialog();
          }
        },
      ),
    );
  }

  ///授权提示
  void showAgreeDialog() {
    BotToast.showCustomText(
      onlyOne: true,
      duration: null,
      crossPage: false,
      toastBuilder: (cancelFunc) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                  Map map = {
                    'role': _roleStr,
                    'companyName': _enterpriseNameController.text,
                    'organization': _xydmController.text,
                    'username': _fddbrController.text
                  };
                  enterprise(map);
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

  Widget _buildEnterpriseInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _enterpriseNameFocusNode,
              controller: _enterpriseNameController,
              enabled: widget.model == null,
              leadingText: Text('企业名称',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: '输入企业全称',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _xydmFocusNode,
              controller: _xydmController,
              enabled: widget.model == null,
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
              // enabled: widget.model == null,
              leadingText: Text('法定代表人',
                  style: TextStyle(
                    fontSize: 16,
                  )),
              hintText: _roleStr == 'AGENT' ? '输入经办人姓名' : '输入法人姓名',
              hideDivider: true,
            ),
          ),
          Container(
              padding: EdgeInsets.all(15),
              child: GestureDetector(
                onTap: _selectRole,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('我的身份'),
                    Expanded(
                        child: Text(
                      _roleStr != ''
                          ? (_roleStr == 'AGENT' ? '我是经办人' : '我是法人')
                          : '请选择身份',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.end,
                    ))
                  ],
                ),
              )),
        ],
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
            '填写企业营业执照上的真实信息',
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Text(
                '$AUTHENTICATION_INFO',
              ))
        ],
      ),
    );
  }

  ///选择身份
  void _selectRole() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(
                '我是法人',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _roleStr = 'LEGAL';
                });
                Navigator.of(context).pop();
              },
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: Colors.grey[300],
            ),
            ListTile(
              title: Text(
                '我是经办人',
                textAlign: TextAlign.center,
              ),
              onTap: () {
                setState(() {
                  _roleStr = 'AGENT';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
}

///认证提示信息
const AUTHENTICATION_INFO = '1.一个企业有3次认证机会，超过三次需要收费。' +
    '\n2.企业一旦认证成功，再次申请认证后不可以修改企业认证信息，如因工商变更需要修改信息请联系平台客服人员。' +
    '\n3企业信息发生变更（如名称、法人等)，请第一时间完成新的认证，如未重新认证导致的一切问题由企业自己承担。';
