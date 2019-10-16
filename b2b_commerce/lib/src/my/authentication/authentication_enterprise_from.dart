import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class AuthenticationEnterpriseFromPage extends StatefulWidget {
  _AuthenticationEnterpriseFromPageState createState() =>
      _AuthenticationEnterpriseFromPageState();
}

class _AuthenticationEnterpriseFromPageState
    extends State<AuthenticationEnterpriseFromPage> {
  FocusNode _enterpriseNameFocusNode = FocusNode();
  FocusNode _xydmFocusNode = FocusNode();
  FocusNode _fddbrFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _idCardFocusNode = FocusNode();
  TextEditingController _enterpriseNameController = TextEditingController();
  TextEditingController _xydmController = TextEditingController();
  TextEditingController _fddbrController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _idCardController = TextEditingController();
  String roleName;
  String role;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('企业认证'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              _buildEnterpriseInfo(),
              _buildAgentInfo(),
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
        onPressed: (){
          if(_enterpriseNameController == null || _enterpriseNameController.text == ''){
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
          }else if(_xydmController == null || _xydmController.text == ''){
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
          }else if(_fddbrController == null || _fddbrController.text == ''){
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
          }else if(_nameController == null || _nameController.text == ''){
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return CustomizeDialog(
                    dialogType: DialogType.RESULT_DIALOG,
                    failTips: '我的姓名不能为空',
                    callbackResult: false,
                    confirmAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                });
          }else if(_idCardController == null || _idCardController.text == ''){
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
          }else if(role == null || role == ''){
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
            Map map = {
              'companyName': _enterpriseNameController.text,
              'organization': _xydmController.text,
              'role': role,
              'username': _nameController.text,
              'idCardNum': _idCardController.text,
              'verifyWay': 'WAY1',
              'companyType': 'TYPE1'
            };
            enterprise(map);
          }
        },
      ),
    );
  }

  Widget _buildEnterpriseInfo(){
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
              leadingText: Text('企业名称',style: TextStyle(fontSize: 16,)),
              hintText: '输入企业全称',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _xydmFocusNode,
              controller: _xydmController,
              leadingText: Text('信用代码',style: TextStyle(fontSize: 16,)),
              hintText: '输入社会统一信用代码',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _fddbrFocusNode,
              controller: _fddbrController,
              leadingText: Text('法定代表人',style: TextStyle(fontSize: 16,)),
              hintText: '输入法人姓名',
              hideDivider: true,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAgentInfo(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Colors.grey[100],
            child: Center(
              child: Text('经办人信息'),
            ),
          ),
          GestureDetector(
            onTap: (){
              _showTypeSelect();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Text('我的身份',style: TextStyle(fontSize: 16,)),
                    ),
                  ),
                  Container(
                    child: Text('${roleName != null ? roleName:'选择身份'}',style: TextStyle(fontSize: 16,color: Colors.grey)),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(height: 0,)
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _nameFocusNode,
              controller: _nameController,
              leadingText: Text('我的姓名',style: TextStyle(fontSize: 16,)),
              hintText: '输入经办人姓名',
            ),
          ),
          Container(
            child: TextFieldComponent(
              textAlign: TextAlign.right,
              focusNode: _idCardFocusNode,
              controller: _idCardController,
              leadingText: Text('身份证号码',style: TextStyle(fontSize: 16,)),
              hintText: '输入身份证号码',
              hideDivider: true,
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
                  title: Text('我是法人'),
                  onTap: () async {
                    setState(() {
                      role = 'LEGAL';
                      roleName = '我是法人';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('我是经办人'),
                  onTap: () async {
                    setState(() {
                      role = 'AGENT';
                      roleName = '我是经办人';
                    });
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      },
    );
  }

  enterprise(Map map){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            ContractRepository().enterpriseAuthentication(map),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if(certification.data !=  null){
          Navigator.push(
            context,MaterialPageRoute(builder: (context) => WebView111Page(urlString :certification.data)),
          );
        }else{
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
      }else{
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
