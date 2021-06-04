import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import 'package:core/core.dart';

class ServiceApplyFormPage extends StatefulWidget {
  @override
  _ServiceApplyFormPageState createState() => _ServiceApplyFormPageState();
}

class _ServiceApplyFormPageState extends State<ServiceApplyFormPage> {
  ///认证信息
  AuthenticationModel authenticationModel;

  final double bottomHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('服务申请'),
      ),
      body: ListView(
        children: [
          _Title(
            text: '申请资质',
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              trailing: _authenticationStateIcon(),
              leading: Text('企业/个人认证'),
            ),
          ),
          _Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              trailing: Text(
                  '${UserBLoC.instance.currentUser?.b2bUnit?.contactPerson}'),
              leading: Text('联系人'),
            ),
          ),
          _Divider(),
          Container(
            color: Colors.white,
            child: ListTile(
              trailing: Text(
                  '${UserBLoC.instance.currentUser?.b2bUnit?.contactPhone}'),
              leading: Text('联系方式'),
            ),
          ),
          _Title(
            text: '注：提交申请后，平台将会审核您的资料，届时会有专员联系您，请耐心等待。',
          ),
        ],
      ),
      bottomSheet: _buildBottom(),
    );
  }

  Widget _buildBottom() {
    return Container(
      height: bottomHeight,
      child: Row(
        children: [
          Expanded(
              child: FlatButton(
            height: bottomHeight,
            child: Text('提交申请'),
            color: Constants.THEME_COLOR_MAIN,
            textColor: Colors.white,
            onPressed: () {
              //校验
              if (isAuthenticated()) {
                DialogHelper.showConfirm(content: '是否确认申请？', confirm: _applay);
              } else {
                DialogHelper.showError(content: '未实名认证用户不能申请服务，请先实名认证后重试');
              }
            },
          ))
        ],
      ),
    );
  }

  ///认证状态图标
  Widget _authenticationStateIcon() {
    return Container(
        child: FutureBuilder<AuthenticationModel>(
      builder:
          (BuildContext context, AsyncSnapshot<AuthenticationModel> snapshot) {
        if (snapshot.data != null) {
          if (authenticationModel.companyState == AuthenticationState.SUCCESS ||
              authenticationModel.personalState ==
                  AuthenticationState.SUCCESS) {
            return Icon(
              Icons.check_circle,
              color: Color.fromRGBO(22, 196, 175, 1),
            );
          }
          return Icon(
            Icons.cancel,
            color: Colors.red,
          );
        } else {
          return Container(
            width: 20,
            height: 20,
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      // initialData: null,
      future: _getData(),
    ));
  }

  ///是否已经认证
  bool isAuthenticated() {
    if (authenticationModel != null) {
      return authenticationModel.companyState == AuthenticationState.SUCCESS ||
          authenticationModel.personalState == AuthenticationState.SUCCESS;
    }
    return false;
  }

  ///获取认证状态
  Future<AuthenticationModel> _getData() async {
    if (authenticationModel == null) {
      // 查询明细
      CertificationState model =
          await ContractRepository().getAuthenticationState();
      authenticationModel = model.data;
    }
    return authenticationModel;
  }

  void _applay() async {
    Function cancelFunc =
        BotToast.showLoading(clickClose: true, crossPage: false);
    BaseResponse response = await OperationAgentRepository.apply();
    cancelFunc.call();
    if (response?.code == 1) {
      BotToast.showText(text: '提交成功');
      Navigator.of(context).pop(true);
    } else if (response?.code == 0) {
      BotToast.showText(text: '${response.msg}');
    } else {
      BotToast.showText(text: '未知错误');
    }
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text('$text',
            style: TextStyle(
              color: Colors.grey,
            )));
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Divider(),
    );
  }
}
